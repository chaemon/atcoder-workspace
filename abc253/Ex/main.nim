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

solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  var ct = Seq[N, N: 0]
  for i in M:
    ct[u[i]][v[i]].inc
    ct[v[i]][u[i]].inc
  var tree = Seq[2^N: mint(0)] # b(bit)が木となるような選び方の個数
  for i in N:
    tree[1 shl i] = 1
  for u in 0..<N:
    for v in u+1..<N:
      if ct[u][v] == 0: continue
      var tree2 = tree # b(bit)が木となるような選び方の個数
      var b = 0
      for i in N:
        if u == i or v == i: continue
        b[i] = 1
      for bu in b.subsets:
        for bv in (b xor bu).subsets:
          let
            bu = bu or [u]
            bv = bv or [v]
          tree2[bu or bv] += tree[bu] * tree[bv] * ct[u][v]
      swap tree, tree2
  var dp = Seq[N, 2^N:mint(0)] # 辺の数, 集合
  dp[0][0] = 1
  for c in 0..N-2:
    for b in 0 ..< 2^N - 1:
      if dp[c][b] == 0: continue
      var v = Seq[int]
      for i in N:
        if b[i] == 0:
          v.add i
      # v[0]は確定
      for b2 in (@v[1 .. ^1]).subsets:
        let
          t = b2.popCount
          b2 = b2 or [v[0]]
        dp[c + t][b or b2] += dp[c][b] * tree[b2]
  for K in 1..N-1:
    let ans = dp[K][(1 shl N) - 1] * mint.fact(K) / mint(M)^K
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, M, u, v)
else:
  discard

