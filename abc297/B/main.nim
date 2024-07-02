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
solveProc solve(S:string):
  var
    R, B, N:seq[int]
    K: int
  ok := true
  for i in S.len:
    if S[i] == 'R':
      R.add i
    elif S[i] == 'B':
      B.add i
    elif S[i] == 'N':
      N.add i
    elif S[i] == 'K':
      K = i
  if B[0] mod 2 == B[1] mod 2:
    ok = false
  if not (R[0] < K and K < R[1]):
    ok = false
  if ok:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

