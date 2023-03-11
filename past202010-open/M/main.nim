include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/tree/heavy_light_decomposition

import atcoder/lazysegtree

const DEBUG = true

proc solve(N:int, Q:int, a:seq[int], b:seq[int], u:seq[int], v:seq[int], c:seq[int]) =
  var g = initGraph[int](N)
  for i in N - 1:g.addBiEdge(a[i], b[i])
  var hld = g.initHeavyLightDecomposition()
  proc op(a, b:int):int =
#    echo "op: ", a, " ", b
    a + b
  proc mapping(a, b:int):int =
    if a == int.inf: b
    else: a
  proc composition(a, b:int):int = 
    if a == int.inf: b
    else: a
  var st = initLazySegTree(N, op, ()=>0, mapping, composition, ()=>int.inf)
  var c0:int
  proc qf(i, j:int) = st.apply(i..<j, c0)
  for q in Q:
    c0 = c[q]
    hld.add(u[q], v[q], qf, 1)
  proc qf2(i, j:int):int = st[i..<j]
  for i in N - 1:
#    debug a[i], b[i],  hld.lca(a[i], b[i])
    echo hld.query(a[i], b[i], 0, qf2, (a, b:int)=>a+b, 1)
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    c[i] = nextInt()
  solve(N, Q, a, b, u, v, c)
#}}}

