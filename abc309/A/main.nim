when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(A:int, B:int):
  if (A, B) in [(1, 2), (2, 1), (2, 3), (3, 2), (4, 5), (5, 4), (5, 6), (6, 5), (7, 8), (8, 7), (8, 9), (9, 8)]:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

