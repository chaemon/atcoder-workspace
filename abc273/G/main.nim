when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, R:seq[int], C:seq[int]):
  var a, b = Array[3: 0]
  for i in N:
    a[R[i]].inc
    b[C[i]].inc
  # a[i]: 行におけるiの個数
  # b[i]: 列におけるiの個数
  # 行1 - 行1をx個
  # 列1 - 列1をy個
  if (a[1] - b[1]) %. 2 != 0: echo 0;return
  var ct = block:
    var ct = Seq[N + 1: mint(0)] # ct[i]は残りの和2がi個の場合の数
    for x in 0 .. a[1]:
      # K = a[1] - 2 * x = b[1] - 2 * y
      let y = (b[1] - a[1] + 2 * x) div 2
      if y notin 0 .. b[1]: continue
      let k = a[1] - 2 * x
      if k < 0: continue
      d := mint(1)
      # a[1]から2 * x個, b[1]から2 * y個
      d *= mint.C(a[1], 2 * x) * mint.fact(2 * x) * mint.invFact(2)^x * mint.invFact(x)
      d *= mint.C(b[1], 2 * y) * mint.fact(2 * y) * mint.invFact(2)^y * mint.invFact(y)
      # 両者からk個とる。行-列間のマッチング
      d *= mint.fact(k)
      # 和2から列をx個, 行をy個とる
      let
        p = b[2] - x
        q = a[2] - y
      if p < 0 or q < 0 or p != q: continue
      d *= mint.P(b[2], x)
      d *= mint.P(a[2], y)
      # 鎖はx + y + k個あり, 和2は残りp個ある
      for t in 0 .. p: # 和2からt個とる
        var d = d
        # t個の配分
        d *= mint.H(x + y + k, t)
        # 配分したものの選び方(行と列で2つある)
        d *= mint.P(p, t)^2
        ct[p - t] += d
    ct
  var dp = block:
    var dp = Seq[N + 1: mint(0)] # 和2がk個のときの場合の数
    dp[0] = mint(1)
    for k in 1 .. N:
      # 和2がk個ある
      # 行の最小をiとし、iは必ず入れる
      # マスを2にして輪っかを作らない
      dp[k] += dp[k - 1] * k
      for t in 2 .. k:
        dp[k] += dp[k - t] * mint.P(k - 1, t - 1) * mint.P(k, t) * mint.inv(2)
    dp
  ans := mint(0)
  for k in 0 .. N:
    ans += ct[k] * dp[k]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var R = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  solve(N, R, C)
else:
  discard

