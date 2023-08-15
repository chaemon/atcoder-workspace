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
solveProc solve(N:int, A:seq[seq[int]], B:seq[seq[int]]):
  var A = A
  proc rotate():seq[seq[int]] =
    result = A
    for i in N:
      for j in N:
        result[i][j] = A[N - j - 1][i]
  for c in 4:
    ok := true
    for i in N:
      for j in N:
        if A[i][j] == 1:
          if B[i][j] == 0:
            ok = false
    if ok: echo YES;return
    A = rotate()
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  var B = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, A, B)
else:
  discard

