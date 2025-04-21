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
  for i in 3:
    let
      j = (i + 1) mod 3
      k = (j + 1) mod 3
    if A[i] == A[j] * A[k]:
      echo YES;return
  echo NO
  doAssert false

when not defined(DO_TEST):
  var A = newSeqWith(3, nextInt())
  solve(A)
else:
  discard

