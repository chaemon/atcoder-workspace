const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, W:seq[int]):
  var S = W.sum
  if S mod 2 == 1: echo 0;return
  S.div= 2
  var dp = Seq[N + 1, S + 1:mint(0)]
  dp[0][0] = 1
  for i in N:
    var dp2 = dp
    for c in 0..N - 1:
      for s in 0..S:
        if dp[c][s] == 0: continue
        let s2 = s + W[i]
        if s2 > S: break
        dp2[c + 1][s2] += dp[c][s]
    swap dp, dp2
  var ans = mint(0)
  for c in 0..N:
    ans += dp[c][S] * mint.fact(c) * mint.fact(N - c)
  echo ans
  Naive:
    var
      P = (0..<N).toSeq
      ans = 0
    while true:
      var a, t = 0
      for i in N:
        if t <= a:
          t += W[P[i]]
        else:
          a += W[P[i]]
      if a == t:
        ans.inc
      if not P.nextPermutation(): break
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var W = newSeqWith(N, nextInt())
  solve(N, W)
else:
  import random
  for _ in 1000:
    let N = 3
    var W = Seq[N: random.rand(1..3)]
    test(N, W)
  discard

