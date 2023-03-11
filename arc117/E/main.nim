include atcoder/extra/header/chaemon_header

import atcoder/extra/math/combination_table

const DEBUG = true

proc C2(n:int):int = n * (n - 1) div 2

const B = 30
var dp, dp2, dps = Seq[B^2 + 1, B + 1, B + 1: int]

proc solve(N:int, K:int):int =
  dp.fill(0)
  dps.fill(0)
  for n in 1..B:
    let u = C2(n)
    dp[u][n][n] = 1
  var c = 0
  while true:
    for k in 0 .. B^2:
      for s in 1 .. B:
        for n in 1 .. B:
          dps[k][s][n] += dp[k][s][n]
    update := false
    dp2.fill(0)
    for k in 0 .. B^2:
      for s in 1 .. B:
        for n in 1 .. B:
          if dp[k][s][n] == 0: continue
          for t in 0..n-1:
            var x = 0 # additional
            while true:
              # n -> n - t -> n - t + x
              # additional: a
              let
                a = 2 * n - t + x
                k2 = k + C2(a)
                s2 = s + n - t + x
                n2 = n - t + x
              if k2 > B^2 or s2 > B or n2 > B: break
              update = true
              dp2[k2][s2][n2] += dp[k][s][n] * int.C(n - 1, t) * int.C(n - t + x, x)
              x.inc
    swap dp, dp2
    c.inc
    if not update: break

  var ans = 0
  # only up or only down
  for n in 1..B:
    let K2 = K - C2(n + 1)
    if K2 < 0: continue
    ans += dps[K2][N][n] * 2
  for n in 1 .. B:
    for a in 1..n-1:
      let b = n - a
      # a: over, b:under
      for k in 0 .. B^2:
        let K2 = K - k - C2(n + 1)
        if K2 < 0: continue
        for s in 1 .. B:
          let N2 = N - s
          if N2 < 0: continue
          ans += dps[k][s][a] * dps[K2][N2][b] * int.C(a + b, a)
  return ans

import bitops
import atcoder/extra/other/bitutils

proc solve_naive(N, K:int):int =
  result = 0
  for b in 0..<2^(N*2):
    if b.popCount != N: continue
    a := initTable[int, int]()
    var s = 0
    for i in 0..<N*2:
      if s notin a: a[s] = 0
      a[s].inc
      if b[i]: s.inc
      else: s.dec
    if s notin a: a[s] = 0
    a[s].inc
    assert s == 0
    var t = 0
    for k, v in a:
      t += C2(v)
    if t == K:
      echo toBitStr(b, N * 2)
      result.inc

const TEST = false

proc test() =
  proc test(N, K:int) =
    let t = solve(N, K)
    let t2 = solve_naive(N, K)
    debug N, K, t, t2
    assert t == t2

  for N in 1..8:
    for K in 1..N^2:
      test(N, K)

# input part {{{
block:
  when TEST:
    test()
  else:
    var N = nextInt()
    var K = nextInt()
    echo solve(N, K)
#}}}

