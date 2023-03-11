when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/scc
import lib/other/bitset

solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  Pred u, v
  var g = initSccGraph(N)
  for i in M:
    g.addEdge(u[i], v[i])
  var
    ans = 0
    scc = g.scc
    belongs = Seq[N: int]
  for i, s in scc:
    ans += s.len * (s.len - 1)
    for v in s:
      belongs[v] = i
  var
    N2 = scc.len
    t = Seq[N2: initBitSet[2000]()]
  for u in N2:
    t[u][u] = 1
  for i in M:
    let
      u = belongs[u[i]]
      v = belongs[v[i]]
    if u != v:
      t[u][v] = 1
  for k in N2:
    for i in N2:
      for j in N2:
        if t[i][k] == 1:
          t[i][j] = t[i][j] or t[k][j]
  for i in N2:
    for j in N2:
      if i != j and t[i][j] == 1:
        ans += scc[i].len * scc[j].len
  echo ans - M
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, u, v)
else:
  discard

