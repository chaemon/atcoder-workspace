const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/segtree

const B = 3 * 10^5 + 10

solveProc solve(N:int, K:int, A:seq[int]):
  var st = initSegTree(B, (a, b:(int, int))=>(a[0]+b[0], a[1]+b[1]),()=>(0, 0))
  for i in 0..<N:
    var p = st[A[i]]
    st[A[i]] = (p[0] + 1, p[1] + A[i])
  var ans = -int.inf
  let M = A.max
  for g in 1..M:
    var S = 0
    var l = 0
    while true:
      # l + 1 .. r
      var r = min(l + g, B - 1)
      if l + 1 > r: break
      let (n, s) = st[l + 1..r]
      S += n * (l + g) - s
      l += g
    if S <= K: ans.max=g
  block:
    var S = 0
    for i in 0..<N: S += M - A[i]
    if K >= S:
      ans.max= (K - S) div N + M
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

