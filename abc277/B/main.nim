when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:seq[string]):
  var appeared = initSet[string]()
  for i in N:
    if S[i][0] notin "HDCS": echo NO;return
    if S[i][1] notin "A23456789TJQK": echo NO;return
    if S[i] in appeared: echo NO;return
    appeared.incl S[i]
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

