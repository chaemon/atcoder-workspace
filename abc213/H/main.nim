const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import atcoder/modint
type mint = modint998244353
const MOD = 998244353

import atcoder/convolution

import lib/math/formal_power_series

# Failed to predict input format
block main:
  let N, M, T = nextInt()
  var a, b = Seq[M: int]
  var p = Seq[M, T + 1: mint]
  for i in M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    for t in 1..T:
      p[i][t] = nextInt()
  var dp = Seq[N, T + 1: mint(0)]
  dp[0][0] = 1
  proc calc(l, r:int) =
    let d = r - l
    if d == 0: return
    if d == 1:
      # do something
      discard
    let m = (l + r) div 2
    calc(l, m)
    if l < m:
      for i in M:
        block:
          # a[i] -> b[i]
          var D = convolution(dp[a[i]][l..<m], p[i][0..<d])
          for t in m..<r:
            dp[b[i]][t] += D[t - l]
        block:
          # b[i] -> a[i]
          var D = convolution(dp[b[i]][l..<m], p[i][0..<d])
          for t in m..<r:
            dp[a[i]][t] += D[t - l]
        discard
    if l + 1 == r: return
    calc(m, r)
  calc(0, T+1)
  echo dp[0][T]
  discard

