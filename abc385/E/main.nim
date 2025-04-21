when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, u:seq[int], v:seq[int]):
  Pred u, v
  var
    g = initGraph[int](N)
    ans = int.inf
  for i in N - 1:
    g.addBiEdge(u[i], v[i])
  for u in N:
    # uを中心にする
    var v:seq[int]
    for e in g[u]:
      let p = g[e.dst].len - 1
      if p > 0:
        v.add p
    v.sort
    for t in v.len:
      # t ..< v.lenを使ってv[t]の木を作る
      let d = v.len - t
      ans.min=N - (v[t] * d + d + 1)
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, u, v)
else:
  discard

