when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, L:int, a:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, L, a)
else:
  discard

