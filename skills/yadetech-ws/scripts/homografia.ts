/**
 * Matriz que encaixa um retângulo dentro de um quadrilátero qualquer.
 *
 * Mockup de aparelho em perspectiva tem a tela recortada como trapézio, e a
 * tela que o site desenha é um retângulo. Escala não resolve isso: precisa de
 * projeção. Aqui a homografia é resolvida de verdade: oito incógnitas, oito
 * equações, uma por coordenada de canto. O resultado sai como o `matrix3d`
 * do CSS, que é a mesma projeção escrita em coluna. Assim os cantos batem
 * exatamente com o arquivo, em vez de serem acertados a olho.
 */
export type Ponto = { x: number; y: number }

export type Quadrilatero = [Ponto, Ponto, Ponto, Ponto]

/**
 * `destino` em pixels, na ordem superior esquerdo, superior direito,
 * inferior direito, inferior esquerdo. Devolve `null` se o quadrilátero for
 * degenerado (três cantos na mesma linha), para o chamador não pintar torto.
 */
export function matrizParaQuadrilatero(
  largura: number,
  altura: number,
  destino: Quadrilatero,
): string | null {
  const origem: Quadrilatero = [
    { x: 0, y: 0 },
    { x: largura, y: 0 },
    { x: largura, y: altura },
    { x: 0, y: altura },
  ]

  const a: number[][] = []
  const b: number[] = []
  for (let i = 0; i < 4; i++) {
    const { x, y } = origem[i]
    const { x: u, y: v } = destino[i]
    a.push([x, y, 1, 0, 0, 0, -u * x, -u * y])
    b.push(u)
    a.push([0, 0, 0, x, y, 1, -v * x, -v * y])
    b.push(v)
  }

  const h = resolve(a, b)
  if (!h) return null

  const [h11, h12, h13, h21, h22, h23, h31, h32] = h
  // matrix3d é coluna a coluna; a terceira linha e coluna ficam neutras
  // porque a projeção é plana.
  return `matrix3d(${h11},${h21},0,${h31},${h12},${h22},0,${h32},0,0,1,0,${h13},${h23},0,1)`
}

/** Eliminação de Gauss com pivô parcial. */
function resolve(a: number[][], b: number[]): number[] | null {
  const n = b.length
  const m = a.map((linha, i) => [...linha, b[i]])

  for (let c = 0; c < n; c++) {
    let pivo = c
    for (let r = c + 1; r < n; r++) {
      if (Math.abs(m[r][c]) > Math.abs(m[pivo][c])) pivo = r
    }
    if (Math.abs(m[pivo][c]) < 1e-9) return null
    ;[m[c], m[pivo]] = [m[pivo], m[c]]

    for (let r = 0; r < n; r++) {
      if (r === c) continue
      const f = m[r][c] / m[c][c]
      if (!f) continue
      for (let k = c; k <= n; k++) m[r][k] -= f * m[c][k]
    }
  }

  return m.map((linha, i) => linha[n] / linha[i])
}
