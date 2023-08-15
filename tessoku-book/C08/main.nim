when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[int], T:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, 0)
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, S, T)
else:
  discard

