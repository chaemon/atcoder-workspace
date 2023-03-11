const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const i6 = mint(6).inv
const i2 = mint(2).inv

proc sum2(n:int):mint = mint(n) * (n + 1) * (2 * n + 1) * i6

proc sum1(n:int):mint = mint(n) * (n + 1) * i2

# Failed to predict input format
solveProc solve(N, X:int):
  if N == 1:
    echo mint(X);return
  var
    ans = mint(0)
    q = X
    k = 1
  while true:
    # k -> k + 1 -> k + 2
    let q2 = (q * k) div (k + 1) + 1
    let d = q - q2
    var jump = false
    if k + 2 <= N:
      let q3 = ((q - d) * (k + 1)) div (k + 2) + 1
      if q2 - d == q3:
        jump = true
    if jump:
      # qがd減少する区間を探す
      proc f(t:int):bool = 
        # t * dがオーバーフローするか?
        if d > 0:
          let u = int.high div d
          if u <= t: return false
        if q < t * d or k + t + 1 > N: return false
        doAssert q - t * d >= 0
        #let l = ((q - t * d) * (k + t)) div (k + t + 1) + 1
        #let r = q - (t + 1) * d
        #if l == r:
        if d * (k + 2 * t + 1) < q:
          return true
        else:
          return false
      if not f(0):
        debug d, q, k
        doAssert false
      #debug q, k
      let t = f.maxRight(0 .. N+1-k)
      #debug k, loop
      # 0 .. tについて(q - t * d) * (k + t)の和を計算
      ans += mint(q) * k * (t + 1) + (- k * mint(d) + q) * sum1(t) - d * sum2(t)
      k = k + t + 1
      q = q - (t + 1) * d
    else:
      ans += mint(q) * k
      k.inc
      q = q - d
    #debug k, q
    if k == N: break
  # 最後だけ足していない
  ans += mint(q) * k
  echo ans
  Naive:
    if N == 1:
      echo mint(X);return
    var
      ans = mint(0)
      q = X
      k = 1
    while true:
      ans += mint(k) * q
      let q2 = (q * k) div (k + 1) + 1
      k.inc
      q = q2
      if k == N: break
    ans += mint(k) * q
    echo ans
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let N, X = nextInt()
    solve(N, X)
else:
  for N in 1..100:
    for X in 1..100:
      test(N, X)
  for N in 1..10000:
    test(N, 1000000000000000000.int)

