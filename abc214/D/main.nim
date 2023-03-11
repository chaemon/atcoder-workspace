const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N:int, u:seq[int], v:seq[int], w:seq[int]):
  var
    a = Seq[tuple[w, u, v: int]]
    dsu = initDSU(N)
    ans = 0
  for i in w.len:
    a.add (w[i], u[i], v[i])
  a.sort
  for (w, u, v) in a:
    ans += w * dsu.size(u) * dsu.size(v)
    dsu.merge(u, v)
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  var w = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  solve(N, u.pred, v.pred, w)

