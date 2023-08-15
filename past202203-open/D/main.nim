when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(T:int, N:int, P:seq[seq[int]]):
  var C = N @ -int.inf
  for k in T:
    for i in N:
      C[i].max=P[k][i]
    echo C.sum
  discard

when not defined(DO_TEST):
  var T = nextInt()
  var N = nextInt()
  var P = newSeqWith(T, newSeqWith(N, nextInt()))
  solve(T, N, P)
else:
  discard

