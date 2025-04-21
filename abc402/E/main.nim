when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, X:int, S:seq[int], C:seq[int], P:seq[int]):
  var
    dp = Seq[2^N, X + 1: float(NaN)]
    p = Seq[N: float]
  for i in N:
    p[i] = P[i] / 100
  proc calc(b, x:int):float =
    if not dp[b][x].isNaN(): return dp[b][x]
    dp[b][x] = 0.0
    for i in N:
      if b[i] == 1 or x + C[i] > X: continue
      dp[b][x].max=p[i] * (calc(b xor [i], x + C[i]) + float(S[i])) + (1.0 - p[i]) * calc(b, x + C[i])
    return dp[b][x]
  echo calc(0, 0)

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var S = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextInt()
    C[i] = nextInt()
    P[i] = nextInt()
  solve(N, X, S, C, P)
else:
  discard

