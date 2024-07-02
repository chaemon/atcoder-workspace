when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, A:seq[int]):
  Pred A
  var
    row, col = Seq[N: 0]
    d0, d1 = 0
  for t in T:
    let
      i = A[t] div N
      j = A[t] mod N
    row[i].inc
    col[j].inc
    if i == j: d0.inc
    if i + j == N - 1: d1.inc
    if row[i] == N or col[j] == N or d0 == N or d1 == N:
      echo t + 1;return
  echo -1
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var A = newSeqWith(T, nextInt())
  solve(N, T, A)
else:
  discard

