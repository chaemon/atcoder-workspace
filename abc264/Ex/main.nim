const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true


include lib/header/chaemon_header
import lib/graph/graph_template

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 20

solveProc solve(N: int, P: seq[int]):
  var P = 0 & P
  var trees = Seq[N: tuple[num, sum: array[B + 1, mint]]]
  block:
    for u in N:
      for i in trees[u].num.len:
        trees[u].num[i] = 0
        trees[u].sum[i] = 0
  # num_trees[u][h]: 頂点uを根とする高さhの完全二分木の数
  trees[0].num[0] = 1
  ans := mint(1)
  g := initGraph[int](N)
  for u in 1 ..< P.len:
    g.addBiEdge(u, P[u])
  var height, parent: seq[int]
  block:
    height = newSeq[int](N)
    parent = newSeq[int](N)
    proc dfs(u, p, h: int) =
      height[u] = h
      parent[u] = p
      for e in g[u]:
        if e.dst == p: continue
        dfs(e.dst, u, h + 1)
    dfs(0, -1, 0)
  echo ans
  for u in 1 ..< N:
    # 頂点uが追加される
    if height[u] <= B:
      u := u
      h := 0
      prev := mint(0)
      next := mint(1)
      trees[u].num[0].inc
      while true:
        let p = parent[u]
        # trees[u].num[h]がprevからnextになるときにtrees[p]への影響を考える
        # trees[p].num[h + 1]とtrees[p].sum[h + 1]が影響を受ける
        s := trees[p].sum[h + 1] - prev # p -> u以外の枝の総和
        trees[p].sum[h + 1] += next - prev # p -> u配下分を処理
        let d = s * (next - prev)
        prev = trees[p].num[h + 1]
        trees[p].num[h + 1] += d
        next = trees[p].num[h + 1]
        if p == 0: ans += d
        u = p
        h.inc
        if u == 0: break
    echo ans
  Naive:
    discard
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  solve(N, P.pred)
else:
  discard

