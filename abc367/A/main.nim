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
solveProc solve(A:int, B:int, C:int):
  var t = C
  while t != B:
    t.inc
    if t == 24: t = 0
    if t == A:
      echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
else:
  discard

