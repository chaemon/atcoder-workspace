when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template, lib/graph/warshall_floyd, lib/graph/dijkstra

# Failed to predict input format
solveProc solve():
  let N, M, Q = nextInt()
  var A, B, C: seq[int]
  for _ in M:
    var
      a, b = nextInt() - 1
      c = nextInt()
    A.add a
    B.add b
    C.add c
  var
    qs:seq[seq[int]]
    used = Seq[M: true]
    dist = Seq[N, N: int.inf]
  for _ in Q:
    let t = nextInt()
    case t:
      of 1:
        let i = nextInt() - 1
        qs.add @[i]
        used[i] = false
      of 2:
        let x, y = nextInt() - 1
        qs.add @[x, y]
      else:
        doAssert false
  for u in N:
    dist[u][u] = 0
  var g = initGraph[int](N)
  for i in M:
    if used[i]:
      g.addBiEdge(A[i], B[i], C[i])
      dist[A[i]][B[i]] = C[i]
      dist[B[i]][A[i]] = C[i]
  var
    w = warshallFloyd(dist)
    ans:seq[int]
  dist = w.dist
  for qi in 0 ..< Q << 1:
    if qs[qi].len == 1:
      let i = qs[qi][0]
      var
        dA = g.dijkstra(A[i])
        dB = g.dijkstra(B[i])
      for x in N:
        for y in N:
          var u = min(int.inf, min(dA[x] + dB[y], dA[y] + dB[x]))
          if u.isInf: continue
          u += C[i]
          dist[x][y].min=u
          dist[y][x] = dist[x][y]
      # A[i], B[i]を追加
      # x -> A[i] - B[i] -> x
      # x -> B[i] - A[i] -> x
      g.addBiEdge(A[i], B[i], C[i])
    else:
      let (x, y) = (qs[qi][0], qs[qi][1])
      if dist[x][y].isInf:
        ans.add -1
      else:
        ans.add dist[x][y]
  ans.reverse
  echo ans.join("\n")
  discard

when not DO_TEST:
  solve()
else:
  discard

