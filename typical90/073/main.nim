const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/graph/graph_template

solveProc solve(N:int, c:seq[string], a:seq[int], b:seq[int]):
  Pred a, b
  var g = initGraph(N)
  for i in N - 1:
    g.addBiEdge(a[i], b[i])
  proc dfs(u, p:int):array[4, mint] = # a, bが出てきたかどうかのビット
    result = [mint(0), mint(0), mint(0), mint(0)]
    if c[u] == "a":
      result[1] += 1
    elif c[u] == "b":
      result[2] += 1
    for e in g[u]:
      if e.dst == p: continue
      var
        a = dfs(e.dst, u)
        result2 = [mint(0), mint(0), mint(0), mint(0)]
      # eを消す: 11 = 3でないとだめ
      for b in 4:
        result2[b] += result[b] * a[3]
      # eを残す
      for b in 4:
        for b2 in 4:
          result2[b or b2] += result[b] * a[b2]
      result = result2.move
  var ans = dfs(0, -1)
  echo ans[3]
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var c = newSeqWith(N, nextString())
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, c, a, b)
#}}}

