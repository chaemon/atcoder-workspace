when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, A: seq[int]):
  Pred A
  var ct = Seq[N: int]
  for i in N * 2 - 1:
    ct[A[i]].inc
  for i in N:
    if ct[i] == 1:
      echo i + 1; return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(2*N-1, nextInt())
  solve(N, A)
else:
  discard

