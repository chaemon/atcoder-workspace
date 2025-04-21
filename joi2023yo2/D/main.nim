when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, W:int, D:int, A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var W = nextInt()
  var D = nextInt()
  var A = newSeqWith(N-2+1, nextInt())
  solve(N, W, D, A)
else:
  discard

