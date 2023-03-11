const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, K:int, X:seq[int], Y:seq[int]):
  var dist = Seq[N, N: int]
  for i in N:
    for j in N:
      let
        dx = X[i] - X[j]
        dy = Y[i] - Y[j]
      dist[i][j] = dx * dx + dy * dy
  var setDist = Seq[2^N: int]
  for b in 2^N:
    if b.popCount <= 1:
      setDist[b] = 0
    else:
      var
        i = b.firstSetBit - 1
        d = setDist[b xor (1 << i)]
      doAssert b[i] == 1
      for j in N:
        if b[j] == 0: continue
        d.max=dist[i][j]
      setDist[b] = d

  var dp = Seq[2^N: int.inf]
  dp[0] = 0
  for k in K:
    var dp2 = Seq[2^N: int.inf]
    for b in 2^N - 1:
      if dp[b] == int.inf: continue
      var v = Seq[int]
      for i in N:
        if b[i] == 0: v. add i
      # v[0]はtrue
      let v0 = v[0]
      v = v[1 .. ^1]
      for b2 in v.subsets:
        let b2 = b2 or (1 << v0)
        dp2[b or b2].min= max(dp[b], setDist[b2])
    dp = dp2.move
  echo dp[2^N - 1]
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, K, X, Y)
