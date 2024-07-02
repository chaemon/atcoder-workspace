when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, K:int, u:seq[int], v:seq[int]):
  Pred u, v
  g := initGraph[int](N)
  for i in u.len:
    g.addBiEdge(u[i], v[i])
  var size = Seq[N: int]
  proc dfs(u, p:int) =
    s := 1
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
      s += size[e.dst]
    size[u] = s
  dfs(0, -1)
  var
    K = K
    l, r = 0 # l .. rを使った
    P = Seq[N: int]
  P[0] = 0
  K -= N
  if K < 0:
    echo NO;return
  proc dfs2(u, p:int) =
    for e in g[u]:
      if e.dst == p: continue
      let s = size[e.dst]
      if K >= s: # LISを1増やす
        K -= s
        r.inc
        P[e.dst] = r
      else:
        l.dec
        P[e.dst] = l
      dfs2(e.dst, u)
  dfs2(0, -1)
  if K > 0:
    echo NO;return
  for i in N:
    P[i] -= l - 1
  echo YES
  echo P.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, K, u, v)
else:
  discard

