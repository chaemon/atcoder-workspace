when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(a:int, b:int):
  if a * 2 == b or a * 2 + 1 == b:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  solve(a, b)
else:
  discard

