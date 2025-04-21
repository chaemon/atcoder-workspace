when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/scc

solveProc solve(N:int, M:int, A:seq[int]):
  Pred A
  var s = initSCCGraph(N)
  for i in N:
    s.addEdge i, A[i]
  var
    root_id = Seq[N: -1]
    root:seq[int]
  for v in s.scc:
    if v.len == 1 and A[v[0]] != v[0]: continue
    let m = v.min
    root.add m
    for u in v:
      root_id[u] = m
  var adj = Seq[N: seq[int]]
  for i in N:
    if root_id[i] != -1: continue
    elif root_id[A[i]] != -1:
      let r = root_id[A[i]]
      adj[r].add i
    else:
      adj[A[i]].add i
  #debug root, adj
  proc dfs(u:int):seq[mint] =
    var p = Seq[M: mint(1)]
    for v in adj[u]:
      var
        a = dfs(v)
      a.cumsum
      for i in M: p[i] *= a[i]
    return p
  var ans = mint(1)
  for r in root:
    var a = dfs(r)
    ans *= a.sum
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

