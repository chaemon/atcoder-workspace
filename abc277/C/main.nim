when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template


solveProc solve(N:int, A:seq[int], B:seq[int]):
  var t = initTable[int, seq[int]]()
  for i in N:
    t[A[i]].add B[i]
    t[B[i]].add A[i]
  var
    vis = initSet[int]()
    ans = 1
  proc dfs(u, p:int) =
    if u in vis: return
    ans.max=u
    vis.incl u
    for v in t[u]:
      if v == p: continue
      dfs(v, u)
  dfs(1, -1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

