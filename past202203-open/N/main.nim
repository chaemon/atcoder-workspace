when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/convolution

solveProc solve(N:int, A:seq[int]):
  let M = A.max
  var
    a, b = M + 1 @ 0
  for i in N:
    a[A[i]].inc
    b[M - A[i]].inc
  var
    c = a.convolution_ll(b)
    ans = 0
  for c in c:
    if c != 0: ans.inc
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

