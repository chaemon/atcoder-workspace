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
solveProc solve(N:int, M:int, A:seq[int], X:seq[seq[int]]):
  var s = Seq[M: 0]
  for i in N:
    for j in M:
      s[j] += X[i][j]
  for j in M:
    if A[j] > s[j]:
      echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt())
  var X = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A, X)
else:
  discard

