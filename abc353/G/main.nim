when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, C:int, M:int, T:seq[int], P:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = nextInt()
  var M = nextInt()
  var T = newSeqWith(M, 0)
  var P = newSeqWith(M, 0)
  for i in 0..<M:
    T[i] = nextInt()
    P[i] = nextInt()
  solve(N, C, M, T, P)
else:
  discard

