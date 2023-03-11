include atcoder/extra/header/chaemon_header

import atcoder/maxflow

# Failed to predict input format
block main:
  const INF = 1000000
  let N = nextInt()
  c := newSeqWith(N, nextString())
  id(i, j) => i * N + j
  g := initMaxFlow[int](N^2 + 2)
  s := N^2
  t := s + 1
  for i in 0..<N:
    for j in 0..<N:
      p := id(i, j)
      if (i + j) mod 2 == 0: # black white
        if c[i][j] == 'B':
          g.addEdge(p, t, INF)
        elif c[i][j] == 'W':
          g.addEdge(s, p, INF)
      else: # white black
        if c[i][j] == 'B':
          g.addEdge(s, p, INF)
        elif c[i][j] == 'W':
          g.addEdge(p, t, INF)
      if i + 1 < N:
        q := id(i + 1, j)
        g.addEdge(p, q, 1)
        g.addEdge(q, p, 1)
      if j + 1 < N:
        q := id(i, j + 1)
        g.addEdge(p, q, 1)
        g.addEdge(q, p, 1)
  echo N * (N - 1) * 2 - g.flow(s, t)
  discard

