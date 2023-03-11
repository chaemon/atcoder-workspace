const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, d:seq[int], u:seq[int], v:seq[int], w:seq[int]):
  g := initUndirectedGraph(N, u, v, w)
  var dp = Seq[N: Array[2: -int.inf]]
  proc dfs(u, p:int) =
    # dp[0]: 上限d[u]個選ぶ
    # dp[1]: 上限d[u] - 1個選ぶ
    a := Seq[int]
    # 各頂点vについて
    # dp[0]にするか、dp[1] + e.weightにするかを選ぶ
    # vは0 -> 1 にしたときの大きい順
    # つまり(dp[1] + e.weight) - dp[0]の大きい順
    # ただし、負になるなら採用しない
    s := 0
    for e in g[u]:
      let v = e.dst
      if v == p: continue
      dfs(v, u)
      s += dp[v][0]
      let d = dp[v][1] + @e - dp[v][0]
      if d > 0:
        a.add d
    a.sort(SortOrder.Descending)
    let S = a.sum
    # dp[0]: aからd[u]個選ぶ + s
    if a.len > d[u]:
      dp[u][0] = s + a[0 ..< d[u]].sum
    else:
      dp[u][0] = s + S
    # dp[1]: aからd[u] - 1個選ぶ + s
    if d[u] == 0:
      dp[u][1] = -int.inf
    elif a.len > d[u] - 1:
      dp[u][1] = s + a[0 ..< d[u] - 1].sum
    else:
      dp[u][1] = s + S
  dfs(0, -1)
  echo dp[0][0]
  discard

when not DO_TEST:
  var N = nextInt()
  var d = newSeqWith(N, nextInt())
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  var w = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  solve(N, d, u.pred, v.pred, w)
else:
  discard

