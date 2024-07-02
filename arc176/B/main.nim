when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
#include lib/header/header

solveProc solve(N:int, M:int, K:int):
  proc pow2(k:int):int =
    doAssert k > 0
    return [6, 2, 4, 8][k mod 4]
  if N < K:
    echo pow2(N)
  else:
    if N == K and N == M - 1:
      echo 0
    else:
      echo pow2(K + (N - K) mod (M - K))
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var M = nextInt()
    var K = nextInt()
    solve(N, M, K)
else:
  discard

