when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

const MOD = 10^9

solveProc solve(N:int, K:int):
  # A[i] = A[i - K] + ... + A[i - 1]
  # A[i - 1] = A[i - 1 - K] + ... + A[i - 2]
  # A[i] - A[i - 1] = A[i - 1] - A[i - 1 - K]
  # A[i] = A[i - 1] * 2 - A[i - 1 - K]
  var A = Seq[N + 1: 1]
  if N <= K - 1:
    echo 1;return
  A[K] = K
  for i in K + 1 .. N:
    A[i] = (A[i - 1] * 2 - A[i - 1 - K]).floorMod(MOD)
  echo A[N]

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

