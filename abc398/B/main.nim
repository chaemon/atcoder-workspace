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
solveProc solve(A:seq[int]):
  Pred A
  var ct = Seq[13: 0]
  for a in A: ct[a].inc
  var v: seq[int]
  for i in 13:
    v.add ct[i]
  v.sort(Descending)
  if v[0] >= 3 and v[1] >= 2:
    echo YES
  else:
    echo NO

when not defined(DO_TEST):
  var A = newSeqWith(7, nextInt())
  solve(A)
else:
  discard

