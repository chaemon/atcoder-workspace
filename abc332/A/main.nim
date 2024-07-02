when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:int, K:int, P:seq[int], Q:seq[int]):
  s := 0
  for i in N:
    s += P[i] * Q[i]
  if s < S: s += K
  echo s
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, 0)
  var Q = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    Q[i] = nextInt()
  solve(N, S, K, P, Q)
else:
  discard

