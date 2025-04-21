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
  for i in 0 .. 3:
    var A = A
    swap A[i], A[i + 1]
    if A == @[1, 2, 3, 4, 5]:
      echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var A = newSeqWith(5, nextInt())
  solve(A)
else:
  discard

