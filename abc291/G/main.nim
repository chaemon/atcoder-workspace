when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/convolution, lib/other/bitutils

# not(a or b) = (not a) and (not b)

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var ans = Seq[N: int]
  for d in 5:
    a := Seq[N: 0]
    b := Seq[N * 2: 0]
    # d桁目を見る
    for i in N:
      if A[i][d] == 0: a[i] = 1
      if B[i][d] == 0: b[i] = 1;b[i + N] = 1
    a.reverse
    c := a.convolution_ll(b)
    for i in N:
      ans[i] += (N - c[i + N]) * 2^d
  echo ans.max

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

