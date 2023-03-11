include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/matrix
import atcoder/extra/other/bitutils

type MT = MatrixType(mint)

const DEBUG = true

proc solve(H:int, W:int) =
  var A = MT.init(2^H, 2^H)
  for b0 in 2^H:
    proc calc(b, b2, i:int) =
      if i == H:
        A[b0][b2].inc
      elif b[i]:
        calc(b, b2, i + 1)
      else:
        var (b, b2) = (b, b2)
        # hanjo
        b[i] = 1
        calc(b, b2, i + 1)
        b[i] = 0
        # vertical
        if i + 1 < H and not b[i + 1]:
          b[i] = 1;b[i + 1] = 1
          calc(b, b2, i + 1)
          b[i] = 0;b[i + 1] = 0
        # horizontal
        b[i] = 1;b2[i] = 1
        calc(b, b2, i + 1)
        b[i] = 0;b2[i] = 0
    calc(b0, 0, 0)
  var b = MT.initVector(2^H)
  b[0] = 1
  b = A^W * b
  echo b[0]
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
#}}}

