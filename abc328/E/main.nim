when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/dsu
import lib/other/bitutils

solveProc solve(N:int, M:int, K:int, u:seq[int], v:seq[int], w:seq[int]):
  Pred u, v
  var ans = int.inf
  for L in N:
    var
      edges, edges2 = Seq[tuple[u, v, w:int]]
    for i in M:
      if u[i] != L and v[i] != L:
        edges.add (u[i], v[i], w[i])
      else:
        edges2.add (u[i], v[i], w[i])
    for b in 2^edges.len:
      if b.popCount != N - 2: continue
      var
        d = initDSU(N)
        W = 0
        ok = true
      for i, p in edges:
        let (u, v, w) = p
        if b[i] == 0: continue
        if d.leader(u) == d.leader(v):
          ok = false;break
        d.merge(u, v)
        W += w
        if W >= K: W -= K
      if not ok: continue
      for (u, v, w) in edges2:
        ans.min= (W + w) mod K
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var w = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  solve(N, M, K, u, v, w)
else:
  discard

