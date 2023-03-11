const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int):
  var a = Seq[K + 1: mint(0)]
  a[0] = 1
  for i in N:
    var a2 = Seq[K + 1: mint(0)]
    for t in 0..K:
      for d in 1..M:
        if t + d <= K:
          a2[t + d] += a[t]
    swap a, a2
  echo a.sum
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K)
else:
  discard

