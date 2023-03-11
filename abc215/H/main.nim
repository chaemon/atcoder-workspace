const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], c:seq[seq[int]]):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  var c = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A, B, c)
else:
  discard

