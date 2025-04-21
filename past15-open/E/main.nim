when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, K:int, A:seq[int]):
  ans := 0
  for b in 2^N:
    if b.popcount != K: continue
    for i in N:
      if b[i] == 1:
        ans += A[i]
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

