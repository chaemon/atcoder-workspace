const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/lazysegtree
import atcoder/segtree

type S = (int, int, int) # zero, one, len
type F = (int, int)

proc op(l, r:S):S = (l[0] + r[0], l[1] + r[1], l[2] + r[2])
proc e():S = (0, 0, 0)
proc mapping(f:F, s:S):S =
  if f[0] == int.inf: return s
  else: return (f[0] * s[2], f[1] * s[2], s[2])
proc composition(f1, f2:F):F =
  if f1[0] == int.inf: f2
  else: f1
proc id():F = (int.inf, int.inf)


solveProc solve(N:int, Q:int, X:int, P:seq[int], C:seq[int], L:seq[int], R:seq[int]):
  proc solve(X:int):seq[int] =
    type LST = LazySegTree.getType(S, F, op, e, mapping, composition, id)
    var st = LST.init(N)
    #var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
    for i in N:
      if X <= P[i]:
        st[i] = (0, 1, 1)
      else:
        st[i] = (1, 0, 1)
    for q in Q:
      var (zero, one, n) = st[L[q] ..< R[q]]
      if C[q] == 1:
        st.apply(L[q] ..< L[q] + zero, (1, 0))
        st.apply(L[q] + zero ..< R[q], (0, 1))
      else:
        st.apply(L[q] ..< L[q] + one, (0, 1))
        st.apply(L[q] + one ..< R[q],  (1, 0))
    for i in N:
      if st[i][0] == 1: result.add 0
      else: result.add 1
  v := solve(X)
  v2 := solve(X + 1)
  for i in N:
    if v[i] == 1 and v2[i] == 0:
      echo i + 1
      break
  discard


when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var X = nextInt()
  var P = newSeqWith(N, nextInt())
  var C = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    C[i] = nextInt()
    L[i] = nextInt() - 1
    R[i] = nextInt()
  solve(N, Q, X, P, C, L, R)
else:
  discard

