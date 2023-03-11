include atcoder/extra/header/chaemon_header
import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

solveProc solve(N, M, K:int, H, C, A, B:seq[int]):
  var g = initGraph[int](N + 1)
  for i in 0..<K: g.addEdge(N, C[i], 0)
  for i in 0..<M:
    if H[A[i]] > H[B[i]]:
      g.addEdge(B[i], A[i])
    else:
      g.addEdge(A[i], B[i])
  let dist = g.dijkstra(N)
  for i in 0..<N:
    if dist[i] == int.inf:
      echo -1
    else:
      echo dist[i]

let N, M, K = nextInt()
let H = Seq[N: nextInt()]
let C = Seq[K: nextInt() - 1]
let (A, B) = unzip(M, (nextInt() - 1, nextInt() - 1))

solve(N, M, K, H, C, A, B)

