const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, K:int):
  if K * 2 > N:
    echo -1;return
  proc build(A:var seq[int], p:Slice[int]) =
    doAssert p.len in 2 * K ..< 4 * K
    var
      X0 = A[p]
      X = newSeqWith(p.len, -1)

    if X.len < 3 * K:
      let r = X.len - K
      X[0 ..< r] = X0[K ..< X.len]
      X[r ..< X.len] = X0[0 ..< K]
    else:
      var s = X0.toSet
      X[0 ..< K] = X0[K ..< 2 * K]
      X[X.len - 2 * K ..< X.len - K] = X0[X.len - K ..< X.len]
      for i in 0 ..< X.len:
        if X[i] >= 0: s.excl(X[i])
      var
        v = s.toSeq.sorted
        t = 0
      for i in 0 ..< X.len:
        if i in 0 ..< K or i in X.len - 2 * K ..< X.len - K: continue
        X[i] = v[t]
        t.inc
      doAssert t == v.len
    A[p] = X
  var A = (1 .. N).toSeq
  var t = 0
  while true:
    let L = N - t
    if L < 4 * K:
      A.build(t ..< A.len)
      break
    else:
      A.build(t ..< t + 2 * K)
      t += 2 * K
  echo A.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  #solve(4, 1)
  for N in 1 .. 100:
    for K in 1 .. N - 1:
      echo "test: ", N, " ", K
      solve(N, K)
  discard
  
