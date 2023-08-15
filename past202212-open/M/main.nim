when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, U:seq[int], V:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, U, V)
else:
  discard

