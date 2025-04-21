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

import lib/math/combination

solveProc solve(N:int, K:int, A:seq[int]):
  var
    ans = mint(0)
    dp = Seq[K + 1: mint(0)]
  for a in A:
    var
      dp2 = Seq[K + 1: mint(0)]
      p = mint(1)
    for s in 0 .. K:
      dp2[s] += p
      p *= a
    for s in 0 .. K:
      var p = mint(1)
      for t in 0 .. s:
        dp2[s] += mint.C(s, t) * dp[s - t] * p
        p *= a
    dp = dp2.move()
    ans += dp[K]
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

