when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search_float
import lib/graph/hopcroft_karp

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var s, g = Seq[tuple[x, y: float]]
  for i in N:
    let x, y = nextfloat()
    s.add (x, y)
  for i in N:
    let x, y = nextfloat()
    g.add (x, y)
  proc dist_index(i, j:int):float =
    return sqrt((s[i].x - g[j].x)^2 + (s[i].y - g[j].y)^2)
  var dist = Seq[N, N: float]
  for i in N:
    for j in N:
      dist[i][j] = dist_index(i, j)
  proc f(T:float):bool =
    var g = initHopCroftKarp(N, N)
    for i in N:
      for j in N:
        if dist[i][j] <= T:
          g.addEdge(i, j)
    return g.maximumMatching().len == N
  echo f.minLeft(0.0 .. 2.0 * 1e+18)
  doAssert false

when not DO_TEST:
  solve()
else:
  discard

