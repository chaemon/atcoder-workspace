when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, D:int, X:seq[int], Y:seq[int]):
  proc dist(i, j:int):int = (X[i] - X[j])^2 + (Y[i] - Y[j])^2
  var vis = Seq[N: false]
  proc dfs(u:int) =
    vis[u] = true
    for v in N:
      if vis[v] or dist(u, v) > D * D: continue
      dfs(v)
  dfs(0)
  for i in N:
    echo if vis[i]: YES else: NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, D, X, Y)
else:
  discard

