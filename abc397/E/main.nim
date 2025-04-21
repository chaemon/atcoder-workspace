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
# Failed to predict input format
solveProc solve():
  var N, K = nextInt()
  let R = K - 1
  var
    u, v = Seq[N * K - 1: int]
    g = initGraph[int](N * K)
    ok = true
  for i in N * K - 1:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    g.addBiEdge(u[i], v[i])
  proc dfs(u, p:int):int =
    if not ok:
      return -1
    var
      s = 1
      a = newSeq[int]()
    for e in g[u]:
      if e.dst == p: continue
      let
        sz = dfs(e.dst, u)
      s += sz
      if not ok: return -1
      let r = sz mod K
      #debug e.dst, r
      if r != 0:
        a.add r
    #debug u, a
    if u != 0:
      if a.len <= 1:
        discard
      elif a.len == 2:
        if a[0] + a[1] != K - 1:
          ok = false
          return -1
      elif a.len >= 3:
        ok = false
        return -1
    else:
      if a.len == 2 and a[0] + a[1] == K - 1:
        discard
      elif a.len == 1:
        discard
      else:
        ok = false
        return -1
    return s
  discard dfs(0, -1)
  if not ok: echo NO
  else: echo YES
  doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

