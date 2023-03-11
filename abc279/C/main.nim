when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(H:int, W:int, S:seq[string], T:seq[string]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  var T = newSeqWith(H, nextString())
  solve(H, W, S, T)
else:
  discard

