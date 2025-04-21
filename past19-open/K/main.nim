when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, K:int, u:seq[int], v:seq[int], A:seq[int]):
  Pred u, v
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(u[i], v[i])
  proc dfs(u, p:int):(seq[int], seq[int]) = # 0: どっちでもいい 1: 選ばない
    proc merge(a, b:seq[int]):seq[int] =
      result = Seq[K + 1: -int.inf]
      for i in 0 .. K:
        if a[i] == -int.inf: continue
        for j in 0 .. K:
          if i + j > K: break
          if b[j] == -int.inf: continue
          result[i + j].max=a[i] + b[j]
    var
      a, b = Seq[K + 1: -int.inf] # a: uを選ぶ, b: uを選ばない
      c:seq[int]
    a[0] = 0
    b[0] = 0
    for e in g[u]:
      if e.dst == p: continue
      var (v, w) = dfs(e.dst, u)
      a = merge(a, w)
      b = merge(b, v)
    c = b
    for i in 0 ..< K:
      if a[i] == -int.inf: continue
      c[i + 1].max= a[i] + A[u]
    return (c, b)
  var (a, _) = dfs(0, -1)
  if a[K] == -int.inf:
    echo -1
  else:
    echo a[K]

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, u, v, A)
else:
  discard

