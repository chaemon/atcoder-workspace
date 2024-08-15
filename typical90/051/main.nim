const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/other/bitutils

solveProc solve(N:int, K:int, P:int, A:seq[int]):
  var
    N1 = N div 2
    N2 = N - N1
    a = Seq[N1 + 1: seq[int]]
  for b in 2^N1:
    var s = 0
    for i in N1:
      if b[i] == 1:
        s += A[i]
    a[b.popCount].add s
  for i in a.len:
    a[i].sort
  var ans = 0
  for b in 2^N2:
    let k = b.popCount
    if k > K or K - k > N1: continue
    var s = 0
    for i in N2:
      if b[i] == 1:
        s += A[i + N1]
    ans += a[K - k].upperBound(P - s)
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var P = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, P, A)
