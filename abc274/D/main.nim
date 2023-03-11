when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, x:int, y:int, A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var x = nextInt()
  var y = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, x, y, A)
else:
  discard

