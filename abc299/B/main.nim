when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, C:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var C = newSeqWith(N, nextInt())
  var R = newSeqWith(N, nextInt())
  solve(N, T, C, R)
else:
  discard

