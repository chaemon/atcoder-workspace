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
  for i in A.len:
    g.addBiEdge(A[i], B[i])
  var ans = -1
  proc dfs(u, p:int):int =
    var a:seq[int]
    for e in g[u]:
      if e.dst == p: continue
      a.add dfs(e.dst, u)
    a.sort(SortOrder.Descending)
    if a.len >= 1 and a[0] > 1:
      ans.max=a[0] + 1
    if a.len >= 4:
      ans.max=a[0] + a[1] + a[2] + a[3] + 1
    if a.len < 3: return 1
    else: return a[0] + a[1] + a[2] + 1
  discard dfs(0, -1)
  echo ans
  doAssert false

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

