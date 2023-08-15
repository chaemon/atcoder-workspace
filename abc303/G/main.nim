when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, B:int, C:int, D:int, x:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var x = newSeqWith(N, nextInt())
  solve(N, A, B, C, D, x)
else:
  discard

