when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:int, T:seq[int]):
  for i in N - 1:
    if T[i + 1] - T[i] <= D:
      echo T[i + 1];return
  echo -1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, D, T)
else:
  discard

