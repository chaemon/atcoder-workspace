include atcoder/extra/header/chaemon_header

import atcoder/extra/math/estimate_modint_frac
import atcoder/extra/other/bitutils
import bitops

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc test() =
  echo "n = ", 10
  var v10 = @[
    5,
    5,
    992395270,
    953401350,
    735035398,
    735035398,
    953401350,
    992395270,
    5,
    5,
  ]
  for i, v in v10:
    echo i, " ", estimate(mint(v))
  echo "n = ", 19
  var v19 = @[
    499122186,
    499122186,
    499110762,
    499034602,
    498608106,
    496414698,
    485691370,
    434999274,
    201035754,
    138645483,
    201035754,
    434999274,
    485691370,
    496414698,
    498608106,
    499034602,
    499110762,
    499122186,
    499122186,
  ]
  for i, v in v19:
    echo i, " ", estimate(mint(v))

proc test2() =
  proc calc(base, n, s:int):int =
    var dp = Seq(2^n, n, n, -1)
    proc calc_sub(b, i, j:int):int =
      if dp[b][i][j] != -1: return dp[b][i][j]
      if i == 0 and j == n - 1:
        let
          white = b.countSetBits()
          black = n - white
        dp[b][i][j] = black
        return black
      var turn:int = 0
      if (j - i) mod 2 == 1: # white's turn
        turn = 1
      if turn == 0:
        result = -int.inf
      else:
        result = int.inf
      if i > 0: # put i - 1
        var b2 = b
        let t = base[i - 1]
        b2[i - 1] = t
        var k = i
        while k <= j and b[k] != t:
          b2[k] = t
          k.inc
        if k == j+1:
          b2 = b
          b2[i - 1] = t
        let r = calc_sub(b2, i - 1, j)
        if turn == 0:
          result.max=r
        else:
          result.min=r
      if j + 1 < n: # put j + 1
        var b2 = b
        let t = base[j + 1]
        b2[j + 1] = t
        var k = j
        while k >= i and b[k] != t:
          b2[k] = t
          k.dec
        if k == i-1:
          b2 = b
          b2[j + 1] = t
        let r = calc_sub(b2, i, j + 1)
        if turn == 0:
          result.max=r
        else:
          result.min=r
#      debug toBitStr(b, n), i, j, result
      dp[b][i][j] = result
    var b = 0
    if base[s] == 1:
      b[s] = 1
    return calc_sub(b, s, s)
  const n = 10
  for base in 0..<2^n:
    for s in 0..<n:
      debug toBitStr(base, n), s, calc(base, n, s)
  discard

proc solve_naive(n:int) =
  var ans = newSeq[mint](n)
  for s in 0..<n:
    # 0..01,,,,,01..1
    # i + 1 < j - 1
    for i in 0..<n:
      for j in 0..<n:
        if i + 1 >= j - 1: continue
        if s - i <= j - s: # black
          ans[s] += mint(2)^(j - i - 3) * j
        else: # white
          ans[s] += mint(2)^(j - i - 3) * (i + 1)
    # 1..10,,,,,10..0
    for i in 0..<n:
      for j in 0..<n:
        if i + 1 >= j - 1: continue
        if s - i >= j - s: # black
          ans[s] += mint(2)^(j - i - 3) * (n - i - 1)
        else: # white
          ans[s] += mint(2)^(j - i - 3) * (n - j)
    # 0..01..1 and 1..10..0
    for i in 0..<n-1:
      ans[s] += (i + 1)
      ans[s] += (n - i - 1)
    # 0*..*0
    ans[s] += mint(n) * mint(2)^(n - 2)
  let t = mint(1)/mint(2)^n
  for s in 0..<n:
    echo ans[s] * t
  return

proc solve(n:int) =
  var ans = newSeq[mint](n)
  for s in 0..<n:
    if s == 0 or s == 1 or s == n - 2 or s == n - 1:
      echo mint(n)/2;continue
    let s = if s <= n - 1 - s: s else: n - 1 - s
    let
      N = (mint(2)^(2 * s) - 4) / 6 * 2
      E = (-4-5*mint(2)^(2*s)-mint(12)*n+3*mint(2)^(2*s)*n+3*mint(2)^(1+2*s)*s)/18
    echo ((mint(2)^n - N) * mint(n) / 2 + E) / mint(2)^n
  return

# input part {{{
block:
#  test()
#test2()
  var n = nextInt()
  solve(n)
#  solve_naive(n)
#}}}
