when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/graph/graph_template

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var ans = 0
  proc dfs(u:int, p = -1):int =
    var
      s = 0
      t = 0
    result = 1
    for e in g[u]:
      if e.dst == p: continue
      let d = dfs(e.dst, u)
      s += d
      t += d * d
      result += d
    if p != -1:
      let d = N - result
      s += d
      t += d * d
    ans += (s * s - t) div 2
  discard dfs(0)
  ans = (N * (N - 1) * (N - 2)) div 6 - ans
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

