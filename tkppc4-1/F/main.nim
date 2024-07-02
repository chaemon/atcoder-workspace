when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[seq[int]], B:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  var B = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A, B)
else:
  discard

