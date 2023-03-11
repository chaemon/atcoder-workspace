include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/math/combination
import atcoder/convolution

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(N:int, p:seq[int]) =
  var g = initGraph[int](N)
  for i in p.len:
    g.addBiEdge(i + 1, p[i])
  var size = Seq[N: 0]
  proc dfs(u, prev:int):seq[mint] =
    size[u] = 1
    result = @[mint(1)]
    for e in g[u]:
      if e.dst == prev: continue
      var v = dfs(e.dst, u)
      size[u] += size[e.dst]
      result = result.convolution(v)
    var result2 = result & mint(0)
    for i in result.len:
      let d = size[u] - 1 - i
      if d > 0:
        result2[i + 1] += result[i] * d
    swap(result, result2)
  let dp = dfs(0, -1)
  ans := mint(0)
  for i in dp.len:
    if i mod 2 == 0: ans += dp[i] * mint.fact(N - i)
    else: ans -= dp[i] * mint.fact(N - i)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var p = newSeqWith(N-2+1, nextInt() - 1)
  solve(N, p)
#}}}

