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
solveProc solve(R:int, N:int, M:int, L:int, s:seq[int]):
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  var s = newSeqWith(L, nextInt())
  solve(R, N, M, L, s)
else:
  discard

