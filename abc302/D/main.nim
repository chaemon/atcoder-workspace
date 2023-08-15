when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, D:int, A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var D = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, D, A, B)
else:
  discard

