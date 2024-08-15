when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, B:int, C:int, A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var B = nextInt()
  var C = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, Y, B, C, A)
else:
  discard

