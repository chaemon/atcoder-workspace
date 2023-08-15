when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(H:int, W:int, A:seq[seq[int]]):
  var S = H @ ".".repeat(W)
  for i in H:
    for j in W:
      if A[i][j] >= 1:
        S[i][j] = 'A' + A[i][j] - 1
    discard
  echo S.join("\n")
  discard

when not defined(DO_TEST):
  let H, W = nextInt()
  var A = [H, W] @ nextInt()
  solve(H, W, A)
else:
  discard

