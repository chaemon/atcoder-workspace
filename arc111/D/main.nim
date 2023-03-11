include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/strong_orientation

proc solve(N:int, M:int, a:seq[int], b:seq[int], c:seq[int]) =
#  var ans = Seq(M, -1) # left: 0, right: 1
  var ans = Seq(M, 0) # left: 1, right: -1
  g := initGraph[int](N)
  var es:Edges[int]
  var eid = newSeq[int]()
  for i in 0..<M:
    if c[a[i]] > c[b[i]]:
      ans[i] = 1
    elif c[a[i]] < c[b[i]]:
      ans[i] = -1
    else:
      let i2 = eid.len
      eid.add(i)
      g.addBiEdge(a[i], b[i], i2)
      es.add(initEdge(a[i], b[i], i2))
  let o = strong_orienation(g, es)
  for i,o in o:
    ans[eid[es[i].weight]] = o
  for i in 0..<M:
    assert ans[i] != 0
    if ans[i] == 1:
      echo "->"
    else:
      echo "<-"
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  var c = newSeqWith(N, nextInt())
  solve(N, M, a, b, c)
#}}}
