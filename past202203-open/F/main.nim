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
solveProc solve(H:int, W:int, N:int, A:seq[seq[int]], C:seq[int]):
  var A = A
  for i in H:
    for j in W:
      A[i][j].dec
  for i in H:
    for j in W:
      if i + 1 < H:
        if A[i][j] != A[i + 1][j] and C[A[i][j]] == C[A[i + 1][j]]:
          echo NO;return
      if j + 1 < W:
        if A[i][j] != A[i][j + 1] and C[A[i][j]] == C[A[i][j + 1]]:
          echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  var C = newSeqWith(N, nextInt())
  solve(H, W, N, A, C)
else:
  discard

