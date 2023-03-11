const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, D:seq[int]):
  var lcma = Seq[2^N:int]
  lcma[0] = 0
  for b in 1 ..< 2^N:
    for i in 0..<N:
      if b[i] == 1:
        if b.countSetBits == 1:
          lcma[b] = D[i]
        else:
          var L = lcma[b xor [i]]
          if L == int.inf:
            lcma[b] = int.inf
          else:
            let g = gcd(D[i], lcma[b xor [i]])
            L.div= g
            # try L * D[i] 
            var d = int.high / L
            if d < D[i]:
              lcma[b] = int.inf
            else:
              lcma[b] = L * D[i]
        break
      assert i != N - 1
  var a = Seq[N + 1: Array[2:mint]] # a[i]: i辺の連結グラフの辺の数が偶数のものと奇数のもの
  a[0] = [mint(1), mint(0)]
  a[1] = [mint(1), mint(0)]
  for n in 2..N:
    u := mint(2)^(n * (n - 1) div 2)
    a[n] = [u / 2, u / 2]
    # 0を含む連結成分のサイズ: k
    for k in 1..n-1:
      var
        u = mint.C(n - 1, k - 1)
        r = n - k
      assert r > 0
      if r == 1:
        for d in 0..1:
          a[n][d] -= a[k][d] * u
      else:
        let R = r * (r - 1) div 2
        for d in 0..1:
          for t in 0..1:
            a[n][(d + t) mod 2] -= a[k][d] * mint(2)^(R - 1) * u


  var dp = Seq[2^N, 2:mint(0)]
  dp[0][0] = 1
  dp[0][1] = 0
  for b in 2^N - 1:
    v := Seq[int]
    for i in N:
      if b[i] == 0:
        v.add i
    let i = v[0]
    v = v[1..^1]
    for b2 in v.subsets:
      var b2 = b2 xor [i]
      s := b2.countSetBits
      t := (s * (s - 1)) div 2
      let L = lcma[b2]
      if L == int.inf: continue
      let u = M div L
      for r in 0..1:
        for p in 0..1:
          dp[b xor b2][(r + p) mod 2] += dp[b][r] * u * a[s][p]
  echo dp[2^N - 1][0] - dp[2^N - 1][1]
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var D = newSeqWith(N, nextInt())
  solve(N, M, D)
else:
  discard

