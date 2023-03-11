include atcoder/extra/header/chaemon_header

import atcoder/maxflow

const DEBUG = true

solveProc solve(H:int, W:int, N:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  var mf = initMFGraph[int](H + W + N + N + 2)
  let s = mf.len - 1
  let t = mf.len - 2
  for i in 0..<H: mf.addEdge(s, i, 1)
  for i in 0..<W: mf.addEdge(H + i, t, 1)
  let base = H + W
  for k in 0..<N:
    mf.addEdge(base+k, base+N+k, 1)
    for i in A[k]..<C[k]:
      mf.addEdge(i, base+k, 1)
    for j in B[k]..<D[k]:
      mf.addEdge(base+ N + k, H + j, 1)
  echo mf.flow(s, t)
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
    D[i] = nextInt()
  solve(H, W, N, A, B, C, D)
#}}}

