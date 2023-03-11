when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, A:seq[int]):
  var dp = Seq[N + 1, 2: -1]
  proc calc(n, a: int):int =
    t =& dp[n][a]
    if t >= 0: return t
    if n == 0: t = 0;return t
    var s = int.inf
    for i in K:
      if A[i] > n: continue
      s.min=calc(n - A[i], 1 - a)
    t = n - s
    return t
  echo calc(N, 0)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(N, K, A)
else:
  discard

