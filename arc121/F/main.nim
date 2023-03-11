include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/graph/graph_template
import atcoder/dsu
import atcoder/extra/other/bitutils

const DEBUG = true

proc solve_naive(N:int, a:seq[int], b:seq[int]) =
  ans := mint(0)
  for bit in 2^(N - 1):
    var uf = initDSU(N)
    for i in N - 1:
      if bit[i]: uf.merge(a[i], b[i])
    var p = mint(1)
    for g in uf.groups:
      p *= mint(2)^g.len - 1
    ans += mint(2)^N - p
  echo ans
  return

proc solve(N:int, a:seq[int], b:seq[int]) =
  g := initGraph[int](N)
  for i in a.len: g.addBiEdge(a[i], b[i])
  proc dfs(u, p:int):auto =
    var v = Seq[array[2, mint]] # 0: all 1, 1: at least one 0
    result = Array[2: mint]
    for e in g[u]:
      if e.dst == p: continue
      v.add dfs(e.dst, u)
    # make u 0
    for ct in 0..1:
      var dp = Array[2: mint]
      dp[1 - ct] = 1
      for v in v:
        var dp2 = Array[2: mint]
        # make edge AND
        # all 1 => all 1 and all 1
        let p = dp[0] * v[0]
        dp2[0] += p
        # at least one 0 => at least one 0 or at least one 0
        dp2[1] += (dp[0] + dp[1]) * (v[0] + v[1]) - p
        # make edge OR
        for i in 0..1: dp2[i] += dp[i] * v[1]
        swap dp, dp2
      for i in 0..1: result[i] += dp[i]
  echo mint(2)^(N + (N - 1)) - dfs(0, -1)[1]
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
#  solve_naive(N, a, b)
#}}}

