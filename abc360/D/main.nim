when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, S:string, X:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var S = nextString()
  var X = newSeqWith(N, nextInt())
  solve(N, T, S, X)
else:
  discard

