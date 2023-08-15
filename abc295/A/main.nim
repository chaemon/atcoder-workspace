when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, W:seq[string]):
  for w in W:
    if w in ["and", "not", "that", "the", "you"]:
      echo YES;return
  echo NO

when not defined(DO_TEST):
  var N = nextInt()
  var W = newSeqWith(N, nextString())
  solve(N, W)
else:
  discard

