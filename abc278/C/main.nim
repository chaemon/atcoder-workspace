when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve():
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

