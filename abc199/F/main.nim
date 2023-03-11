include atcoder/extra/header/chaemon_header

import atcoder/extra/math/matrix

import atcoder/modint
type mint = modint1000000007

let half = 1 / mint(2)

const DEBUG = true

block main:
  let N, M, K = nextInt()
  let A = Seq[N: nextInt()]
  type MT = MatrixType(mint)
  var P = MT.init(N, N)
  let p = 1 / mint(M)
  for _ in M:
    var X, Y = nextInt()
    X.dec;Y.dec
    for i in 0..<N:
      if i != X and i != Y:
        P[i][i] += p
    P[X][Y] += p * half
    P[X][X] += p * half
    P[Y][X] += p * half
    P[Y][Y] += p * half
  P ^= K
  var b = MT.initVector(N)
  for i in 0..<N:
    b[i] = A[i]
  b = P * b
  for b in b:
    echo b
  discard

