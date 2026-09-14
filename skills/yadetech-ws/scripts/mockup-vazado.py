"""Recorta mockup de aparelho: tela magenta -> vazado, fundo branco -> alfa.

    python3 scripts/mockup-vazado.py entrada.png public/images/mockup-x-v1.png

O mockup gerado por IA vem com a tela pintada de magenta chapado e fundo
branco (contrato do prompt em referencias/mockups.md). Este script transforma
isso no arquivo que o site usa: tela e fundo viram transparência, a borda
serrilhada é desmisturada do branco para não virar halo no palco escuro, o
quadro é recortado no aparelho e, no fim, saem os números que o componente de
aparelho precisa: os quatro cantos do vazado em porcentagem do arquivo.

Aparelho de frente dá um retângulo (vira `tela` no mockup); aparelho em
perspectiva dá um quadrilátero (vira `quad`, e a tela entra por projeção,
via `homografia.ts`).

Entrada: PNG de 8 bits, sem entrelace, RGB ou RGBA. JPEG ou WebP vira PNG
antes: `sips -s format png entrada.jpg --out entrada.png`. Aparelho com corpo
escuro: prata sobre fundo branco faz a enchente comer a moldura.

Sem dependência: PNG entra e sai com `zlib` e `struct` da biblioteca padrão,
porque instalar Pillow para quatro arquivos não se paga.
"""
import struct, sys, zlib
from collections import deque


def le_png(caminho):
    dados = open(caminho, 'rb').read()
    assert dados[:8] == b'\x89PNG\r\n\x1a\n', 'não é PNG'
    i, idat = 8, bytearray()
    w = h = ct = 0
    while i < len(dados):
        (tam,) = struct.unpack('>I', dados[i:i + 4])
        tipo = dados[i + 4:i + 8]
        corpo = dados[i + 8:i + 8 + tam]
        if tipo == b'IHDR':
            w, h, bd, ct, _, _, inter = struct.unpack('>IIBBBBB', corpo)
            assert bd == 8 and inter == 0, 'só 8 bits sem entrelace'
            assert ct in (2, 6), 'reexporte como RGB ou RGBA de 8 bits (sem paleta, sem cinza)'
        elif tipo == b'IDAT':
            idat += corpo
        elif tipo == b'IEND':
            break
        i += 12 + tam

    canais = {0: 1, 2: 3, 4: 2, 6: 4}[ct]
    cru = zlib.decompress(bytes(idat))
    stride = w * canais
    saida = bytearray(w * h * stride // w if False else w * h * canais)
    ant = bytearray(stride)
    p = 0
    for y in range(h):
        f = cru[p]; p += 1
        lin = bytearray(cru[p:p + stride]); p += stride
        if f == 1:
            for x in range(canais, stride):
                lin[x] = (lin[x] + lin[x - canais]) & 255
        elif f == 2:
            for x in range(stride):
                lin[x] = (lin[x] + ant[x]) & 255
        elif f == 3:
            for x in range(stride):
                a = lin[x - canais] if x >= canais else 0
                lin[x] = (lin[x] + ((a + ant[x]) >> 1)) & 255
        elif f == 4:
            for x in range(stride):
                a = lin[x - canais] if x >= canais else 0
                b = ant[x]
                c = ant[x - canais] if x >= canais else 0
                pa, pb, pc = abs(b - c), abs(a - c), abs(a + b - 2 * c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                lin[x] = (lin[x] + pr) & 255
        saida[y * stride:(y + 1) * stride] = lin
        ant = lin
    return w, h, canais, saida


def grava_png_rgba(caminho, w, h, pix):
    stride = w * 4
    linhas = bytearray()
    for y in range(h):
        linhas.append(0)
        linhas += pix[y * stride:(y + 1) * stride]

    def parte(tipo, corpo):
        return (struct.pack('>I', len(corpo)) + tipo + corpo
                + struct.pack('>I', zlib.crc32(tipo + corpo) & 0xffffffff))

    ihdr = struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0)
    open(caminho, 'wb').write(
        b'\x89PNG\r\n\x1a\n' + parte(b'IHDR', ihdr)
        + parte(b'IDAT', zlib.compress(bytes(linhas), 9)) + parte(b'IEND', b''))


def processa(entrada, saida):
    w, h, canais, pix = le_png(entrada)
    n = w * h

    # 1. Máscara da tela. O teste é de croma, não de cor exata: assim ele pega
    #    também o pixel meio magenta da borda serrilhada.
    tela = bytearray(n)
    for i in range(n):
        r, g, b = pix[i * canais], pix[i * canais + 1], pix[i * canais + 2]
        if r - g > 40 and b - g > 40:
            tela[i] = 1

    # Engorda um pixel: sobra de magenta na borda vira linha rosa na tela.
    cheia = bytearray(tela)
    for y in range(h):
        for x in range(w):
            if not tela[y * w + x]:
                continue
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    yy, xx = y + dy, x + dx
                    if 0 <= yy < h and 0 <= xx < w:
                        cheia[yy * w + xx] = 1
    tela = cheia

    # 2. Fundo branco: enchente a partir da borda, para não furar o brilho
    #    claro que está dentro do aparelho.
    fundo = bytearray(n)
    fila = deque()

    def claro(i):
        r, g, b = pix[i * canais], pix[i * canais + 1], pix[i * canais + 2]
        return r >= 232 and g >= 232 and b >= 232

    for x in range(w):
        for i in (x, (h - 1) * w + x):
            if not fundo[i] and claro(i):
                fundo[i] = 1; fila.append(i)
    for y in range(h):
        for i in (y * w, y * w + w - 1):
            if not fundo[i] and claro(i):
                fundo[i] = 1; fila.append(i)
    while fila:
        i = fila.popleft()
        y, x = divmod(i, w)
        for yy, xx in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if 0 <= yy < h and 0 <= xx < w:
                j = yy * w + xx
                if not fundo[j] and claro(j):
                    fundo[j] = 1; fila.append(j)

    # 3. Recorte no aparelho: o que não é fundo manda.
    x0, y0, x1, y1 = w, h, -1, -1
    for y in range(h):
        base = y * w
        for x in range(w):
            if not fundo[base + x]:
                if x < x0: x0 = x
                if x > x1: x1 = x
                if y < y0: y0 = y
                if y > y1: y1 = y
    lx, ly = x1 - x0 + 1, y1 - y0 + 1

    # 4. Cantos da tela, dentro do recorte.
    somas = {'tl': (1 << 30, None), 'br': (-1, None), 'tr': (-(1 << 30), None), 'bl': (1 << 30, None)}
    for y in range(h):
        base = y * w
        for x in range(w):
            if not tela[base + x]:
                continue
            s, d = x + y, x - y
            if s < somas['tl'][0]: somas['tl'] = (s, (x, y))
            if s > somas['br'][0]: somas['br'] = (s, (x, y))
            if d > somas['tr'][0]: somas['tr'] = (d, (x, y))
            if d < somas['bl'][0]: somas['bl'] = (d, (x, y))

    # 5. Saída RGBA: tela e fundo transparentes, borda do fundo amaciada.
    fora = bytearray(lx * ly * 4)
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            i = y * w + x
            o = ((y - y0) * lx + (x - x0)) * 4
            r, g, b = pix[i * canais], pix[i * canais + 1], pix[i * canais + 2]
            if tela[i] or fundo[i]:
                # Transparente sai preto, não magenta nem branco: quando o
                # navegador reduz a imagem ele mistura a cor dos vizinhos, e
                # franja escura desaparece no palco escuro do site.
                a = r = g = b = 0
            else:
                a = 255
                vizinho = any(
                    fundo[(y + dy) * w + (x + dx)]
                    for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1))
                    if 0 <= y + dy < h and 0 <= x + dx < w
                )
                if vizinho and min(r, g, b) > 200:
                    a = max(0, min(255, int((248 - min(r, g, b)) * 255 / 48)))
                    if a == 0:
                        r = g = b = 0
                    else:
                        # A borda serrilhada foi fotografada sobre branco. Sem
                        # desfazer essa mistura, ela vira halo claro no escuro.
                        f = a / 255
                        r, g, b = (
                            max(0, min(255, int((c - 255 * (1 - f)) / f)))
                            for c in (r, g, b)
                        )
            fora[o] = r; fora[o + 1] = g; fora[o + 2] = b; fora[o + 3] = a

    grava_png_rgba(saida, lx, ly, fora)

    def pct(ponto):
        x, y = ponto
        return round((x - x0) / lx * 100, 3), round((y - y0) / ly * 100, 3)

    cantos = {k: pct(v[1]) for k, v in somas.items()}
    print(f'{saida}  {lx}x{ly}')
    for k in ('tl', 'tr', 'br', 'bl'):
        print(f'  {k}: {cantos[k][0]:.3f}% , {cantos[k][1]:.3f}%')
    largura = ((cantos['tr'][0] - cantos['tl'][0]) + (cantos['br'][0] - cantos['bl'][0])) / 2 / 100 * lx
    altura = ((cantos['bl'][1] - cantos['tl'][1]) + (cantos['br'][1] - cantos['tr'][1])) / 2 / 100 * ly
    print(f'  tela média: {largura:.0f}x{altura:.0f} px  (proporção {largura / altura:.3f})')


if __name__ == '__main__':
    processa(sys.argv[1], sys.argv[2])
