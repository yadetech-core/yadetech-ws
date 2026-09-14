"""Mede a tela de um mockup que já chegou com a tela transparente.

    python3 scripts/medir-furo.py public/images/mockup-celular-v1.png [outro.png ...]

Para mockup que não passou pelo `mockup-vazado.py` (veio pronto, com a tela e o
fundo transparentes). O que é transparente e toca a borda do arquivo é o fundo;
o transparente cercado pelo aparelho é o furo da tela. Sai o retângulo do furo
em porcentagem do arquivo, pronto para o campo `tela` do mockup.

Serve para aparelho de frente. Em perspectiva, use o `mockup-vazado.py` no
original, que imprime os quatro cantos.
"""
import importlib.util, os, sys
from collections import deque

_aqui = os.path.dirname(os.path.abspath(__file__))
_spec = importlib.util.spec_from_file_location('vazado', os.path.join(_aqui, 'mockup-vazado.py'))
_vazado = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_vazado)


def mede(caminho):
    w, h, c, pix = _vazado.le_png(caminho)
    if c < 4:
        print(f'{caminho}: sem canal alfa, nada a medir')
        return
    transparente = lambda i: pix[i * c + 3] < 128
    fora = bytearray(w * h)
    fila = deque()
    for x in range(w):
        for i in (x, (h - 1) * w + x):
            if transparente(i) and not fora[i]:
                fora[i] = 1
                fila.append(i)
    for y in range(h):
        for i in (y * w, y * w + w - 1):
            if transparente(i) and not fora[i]:
                fora[i] = 1
                fila.append(i)
    while fila:
        i = fila.popleft()
        y, x = divmod(i, w)
        for yy, xx in ((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)):
            if 0 <= yy < h and 0 <= xx < w:
                j = yy * w + xx
                if not fora[j] and transparente(j):
                    fora[j] = 1
                    fila.append(j)
    x0, y0, x1, y1 = w, h, -1, -1
    for y in range(h):
        base = y * w
        for x in range(w):
            i = base + x
            if not fora[i] and transparente(i):
                x0, x1 = min(x0, x), max(x1, x)
                y0, y1 = min(y0, y), max(y1, y)
    if x1 < 0:
        print(f'{caminho}  {w}x{h}: nenhum furo cercado pelo aparelho')
        return
    print(f'{caminho}  {w}x{h}')
    print(f"  tela: {{ left: '{x0 / w * 100:.3f}%', top: '{y0 / h * 100:.3f}%', "
          f"width: '{(x1 - x0 + 1) / w * 100:.3f}%', height: '{(y1 - y0 + 1) / h * 100:.3f}%' }}")
    print(f'  furo: {x1 - x0 + 1}x{y1 - y0 + 1} px  (proporção {(x1 - x0 + 1) / (y1 - y0 + 1):.3f})')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for arquivo in sys.argv[1:]:
        mede(arquivo)
