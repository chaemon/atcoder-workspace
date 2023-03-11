const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, c:seq[string], k:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var c = newSeqWith(K, "")
  var k = newSeqWith(K, 0)
  for i in 0..<K:
    c[i] = nextString()
    k[i] = nextInt()
  solve(N, K, c, k)

