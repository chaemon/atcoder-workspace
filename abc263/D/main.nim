const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/dp/cumulative_sum

solveProc solve(N:int, L:int, R:int, A:seq[int]):
  var
    S = A.sum
    s = 0
    smin = 0
    rs = newSeq[int](N + 1)
    ans = int.inf
  block:
    var s = 0
    rs[N] = 0
    for i in 0 ..< N << 1:
      s += R - A[i]
      rs[i] = s
  for i in 0 .. N:
    # 0 ..< i
    ans.min= smin + rs[i] + S
    if i == N: break
    s += L - A[i]
    smin.min= s
    # sは0 .. iをLにした場合の差分
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, R, A)
else:
  discard

