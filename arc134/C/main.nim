const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int, K:int, a:seq[int]):
  d := a[0] - (a[1..<N].sum + K)
  if d < 0: echo 0;return
  ans := mint(1)
  for i in 1..<N:
    ans *= mint.C_large(a[i] + K - 1, K - 1)
  ans *= mint.C_large(d + K - 1, K - 1)
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
else:
  discard

