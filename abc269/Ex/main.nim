when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/heavy_light_decomposition

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/convolution
import lib/other/fold

#block:
#  v := @[3, 1, 4, 1, 5, 9]
#  echo v.fold_associative((a, b:int)=>a+b)

proc sum(a, b:seq[mint]):seq[mint] =
  result = a
  while result.len < b.len:
    result.add mint(0)
  for i in b.len:
    result[i] += b[i]

prod(a, b:seq[mint]) => convolution(a, b)

solveProc solve(N:int, P:seq[int]):
  var
    P = -1 & P
    g = initGraph[int](N)
  for i in 1 ..< N:
    g.addBiEdge(i, P[i])
  var hld = initHeavyLightDecomposition(g)

  proc dfs(u, p:int):seq[mint] =
    let h = hld.head[u]
    doAssert h == u
    var a: seq[seq[mint]]
    for c in hld.heavy_path[u]:
      var m = collect(newSeq):
        for l in hld.light_child[c]:
          dfs(l, c)
      m = @[mint(1)] & m
      a.add m.fold_associative(prod)
    # 遅いやりかた
    #result = @[mint(1)]
    #for i in 0 ..< a.len << 1:
    #  result = result.convolution(a[i])
    #  while result.len < 2: result.add mint(0)
    #  result[1] += 1
    #debug result
    result = sum(a.fold_associative(prod), fold_staircase_sum(@[mint(0), mint(1)] & a[0 .. ^2], sum, prod))
  var ans = dfs(0, -1)
  ans = ans[1 .. ^1]
  while ans.len < N: ans.add 0
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  solve(N, P.pred)
else:
  discard

