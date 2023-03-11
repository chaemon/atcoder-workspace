include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template

const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  var a = Seq[N, N: true]
  let (A, B) = unzip(M, (nextInt() - 1, nextInt() - 1))
  g := initGraph[int](N)
  for i in 0..<M: g.addBiEdge(A[i], B[i])
  vis := Seq[N : false]
  col := Seq[N : -1]
  ans := 1
  var v = Seq[int]
  proc dfs(u, p:int) =
    vis[u] = true
    v.add(u)
    for e in g[u]:
      if e.dst == p or vis[e.dst]: continue
      dfs(e.dst, u)
  var vs:seq[seq[int]]
  for u in 0..<N:
    if vis[u]: continue
    v.setLen(0)
    dfs(u, -1)
    vs.add(v)
  for v in vs:
    ans0 := 0
    proc dfs(i:int) =
      if i == v.len:
        ans0.inc;return
      for c in 0..<3:
        valid := true
        for e in g[v[i]]:
          if col[e.dst] == c: valid = false;break
        if not valid: continue
        col[v[i]] = c
        dfs(i + 1)
        col[v[i]] = -1
    dfs(0)
    ans *= ans0
  echo ans
