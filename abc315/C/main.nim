when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, F:seq[int], S:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var F = newSeqWith(N, 0)
  var S = newSeqWith(N, 0)
  for i in 0..<N:
    F[i] = nextInt()
    S[i] = nextInt()
  solve(N, F, S)
else:
  discard

