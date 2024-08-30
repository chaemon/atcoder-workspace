when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    c = 0
    A = A
  while true:
    A.sort(SortOrder.Descending)
    if A[0] > 0 and A[1] > 0:
      A[0].dec
      A[1].dec
      c.inc
    else:
      break
  echo c
  discard


when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

