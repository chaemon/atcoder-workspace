const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, Q:int, a:seq[int], b:seq[int], c:seq[int], u:seq[int], v:seq[int], w:seq[int]):
  var
    dsu = initDSU(N)
    ans = Seq[Q:bool]
  var A = Seq[tuple[c, i, t:int]]
  for i in M:
    A.add((c[i], i, 0))
  for i in Q:
    A.add((w[i], i, 1))
  A.sort
  for (c, i, t) in A:
    if t == 0:
      dsu.merge(a[i], b[i])
    else:
      if dsu.leader(u[i]) == dsu.leader(v[i]):
        ans[i] = false
      else:
        ans[i] = true
  for i in ans:
    if i:
      echo YES
    else:
      echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    c[i] = nextInt()
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  var w = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    w[i] = nextInt()
  solve(N, M, Q, a, b, c, u, v, w)
else:
  discard

