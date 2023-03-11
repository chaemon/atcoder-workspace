const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/matrix, lib/math/combination

type MT = StaticMatrixType(mint)

solveProc solve(N:int, D:int):
  # b[0]: 最初が白
  # b[1]: 最初が黒
  var ans = mint(0)
  for n in 0 .. D + 1:
    # すべての辺で白い石がn個
    let
      A = MT.init([
        [mint.C(D - 1, n),     mint.C(D - 1, n - 1)], 
        [mint.C(D - 1, n - 1), mint.C(D - 1, n - 2)]])
    for i in 0..1:
      var b = MT.initVector([0, 0])
      b[i] = 1
      b = A^N * b
      ans += b[i]
  echo ans

when not DO_TEST:
  var N = nextInt()
  var D = nextInt()
  solve(N, D)
else:
  discard

