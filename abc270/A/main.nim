when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(A:int, B:int):
  ans := 0
  for i in 3:
    if A[i] == 1 or B[i] == 1:
      ans[i] = 1
  echo ans
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

