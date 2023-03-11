const DEBUG = true
include lib/header/chaemon_header
import atcoder/maxflow

solveProc solve(N, M:int, S:seq[string]):
  # Kuston
  var g = init_mf_graph[int]((N*M)+2)
  let SRC = N*M
  let SNK = N*M+1

  for i in 0..<N:
    for j in 0..<M:
      if S[i][j] == '#':
        continue
      let x = i * M + j
      if (i + j) mod 2 == 0:
        g.add_edge(SRC, x, 1)
        if i > 0:
          g.add_edge(x, x-M, 1)
        if j > 0:
          g.add_edge(x, x-1, 1)
        if i < N-1:
          g.add_edge(x, x+M, 1)
        if j < M-1:
          g.add_edge(x, x+1, 1)
      else:
        g.add_edge(x, SNK, 1)
  
  echo g.flow(SRC, SNK)

  var ans = S

  for e in g.edges:
    if e.src == SRC or e.dst == SNK:
      continue
    if e.flow == 0:
      continue
    let sx = e.src mod M
    let sy = e.src div M
    let dx = e.dst mod M
    let dy = e.dst div M

    let df = e.dst - e.src
    if df == 1:
      ans[sy][sx] = '>'
      ans[dy][dx] = '<'
    elif df == -1:
      ans[sy][sx] = '<'
      ans[dy][dx] = '>'
    elif df == M:
      ans[sy][sx] = 'v'
      ans[dy][dx] = '^'
    else:
      ans[sy][sx] = '^'
      ans[dy][dx] = 'v'
  echo ans.join("\n")
  Naive:
    let n = N
    let m = M
    var S = S
    # generate (s -> even S -> odd S -> t) graph
    # S(i, j) correspond to vertex (i * m + j)
    var g = initMFGraph[int](n * m + 2)
    let
      s = n * m
      t = n * m + 1;
  
    # s -> even / odd -> t
    for i in 0..<n:
      for j in 0..<m:
        if S[i][j] == '#': continue
        let v = i * m + j
        if (i + j) mod 2 == 0:
          g.add_edge(s, v, 1)
        else:
          g.add_edge(v, t, 1)
  
    # even -> odd
    for i in 0..<n:
      for j in 0..<m:
        if (i + j) mod 2 == 1 or S[i][j] == '#': continue
        let v0 = i * m + j
        if i != 0 and S[i - 1][j] == '.':
          let v1 = (i - 1) * m + j
          g.add_edge(v0, v1, 1)
        if j != 0 and S[i][j - 1] == '.':
          let v1 = i * m + (j - 1)
          g.add_edge(v0, v1, 1)
        if i + 1 < n and S[i + 1][j] == '.':
          let v1 = (i + 1) * m + j
          g.add_edge(v0, v1, 1)
        if j + 1 < m and S[i][j + 1] == '.':
          let v1 = i * m + (j + 1)
          g.add_edge(v0, v1, 1)
  
    echo g.flow(s, t)
  
    let edges = g.edges()
    for e in edges:
      if e.src == s or e.dst == t or e.flow == 0: continue
      let
        i0 = e.src div m
        j0 = e.src mod m
        i1 = e.dst div m
        j1 = e.dst mod m
  
      if i0 == i1 + 1:
        S[i1][j1] = 'v'; S[i0][j0] = '^'
      elif j0 == j1 + 1:
        S[i1][j1] = '>'; S[i0][j0] = '<'
      elif i0 == i1 - 1:
        S[i0][j0] = 'v'; S[i1][j1] = '^'
      else:
        S[i0][j0] = '>'; S[i1][j1] = '<';
  
    echo S.join("\n")
    return

import lib/other/bitutils

proc `*`(c:char or string, n:int):string = c.repeat(n)

for N in 1 .. 5:
  for M in 1 .. 5:
    for b in 2^(N*M):
      var S = Seq[N: '.'.repeat(M)]
      for i in N:
        for j in M:
          let id = M * i + j
          if b[id] == 1:
            S[i][j] = '#'
      debug N, M, S
      test(N, M, S)

#block:
#  let N, M = nextInt()
#  let S = newSeqWith(N, nextString())
#  solve(N, M, S)

