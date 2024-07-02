when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 333

solveProc solve(N:int, A:seq[int]):
  var r = Seq[B: seq[mint]]
  for i in 1 ..< B:
    r[i] = Seq[i + 1: mint(0)]
  var dp = Seq[N: mint(0)]
  dp[0] = 1
  for i in N:
    if A[i] < B:
      for r in 1 ..< B:
        let 
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

