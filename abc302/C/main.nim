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
solveProc solve(N:int, M:int, S:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

