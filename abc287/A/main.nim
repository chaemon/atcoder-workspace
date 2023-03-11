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
  var a = 0
  for i in N:
    if S[i] == "For": a.inc
  let b = N - a
  if a > b: echo YES
  else: echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

