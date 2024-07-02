when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:seq[int], B:seq[int]):
  echo A.sum - B.sum + 1
  discard

when not defined(DO_TEST):
  var A = newSeqWith(9, nextInt())
  var B = newSeqWith(8, nextInt())
  solve(A, B)
else:
  discard

