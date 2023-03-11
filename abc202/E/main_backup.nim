include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template

const DEBUG = true

proc solve(N:int, P:seq[int], Q:int, U:seq[int], D:seq[int]) =
  var g = initGraph[int](N)
  for i in 0..<P.len:
    g.addBiEdge(i + 1, P[i])
  var q = Seq[N:seq[tuple[U, D, i:int]]]
  for i in Q: q[U[i]].add((U[i], D[i], i))
  var ans0 = Seq[Q:int]
  proc dfs(u, p = -1, h = 0):tuple[c:int, v:seq[int]] =
    var ans = Seq[int]
    var c0 = 0
    for e in g[u]:
      if e.dst == p: continue
      var (c, v) = dfs(e.dst, u, h + 1)
      if c0 < c: swap(ans, v); swap(c, c0)
      c0 += c
      for i, val in v:
        let j = v.len - 1 - i
        ans[ans.len - 1 - j] += val
    ans.add(1)
    c0.inc
    for (U, D, i) in q[u]:
      let D = D - h
      if D notin 0..<ans.len:
        ans0[i] = 0
      else:
        ans0[i] = ans[ans.len - 1 - D]
    return (c0, ans)
  discard dfs(0)
  for a in ans0:
    echo a
  return

# input part {{{
block:
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt() - 1)
  var Q = nextInt()
  var U = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    U[i] = nextInt() - 1
    D[i] = nextInt()
  solve(N, P, Q, U, D)
#}}}

