include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true

import atcoder/extra/other/bitutils
import atcoder/extra/graph/graph_template

const B = 60

proc solve(N:int, u:seq[int], v:seq[int], w:seq[int]) =
  var ans0 = mint(0)
  var g = initUndirectedGraph(N, u, v, w)
  for t in B:
    var ans = mint(0)
    proc dfs(u:int, p = -1):array[2, mint] =
      result[0] = 1
      for e in g[u]:
        if e.dst == p: continue
        var a = dfs(e.dst, u)
        if e.weight[t]: swap a[0], a[1]
        ans += result[0] * a[1] + result[1] * a[0]
        for i in 0..1: result[i] += a[i]
    discard dfs(0)
    ans0 += mint(2)^t * ans
  echo ans0
  return

# input part {{{
block:
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  var w = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    w[i] = nextInt()
  solve(N, u, v, w)
#}}}

