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
solveProc solve(S:seq[int]):
  for i in S.len - 1:
    if S[i] > S[i + 1]: echo NO;return
  for s in S:
    if s notin 100 .. 675: echo NO;return
    if s mod 25 != 0: echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var S = newSeqWith(8, nextInt())
  solve(S)
else:
  discard

