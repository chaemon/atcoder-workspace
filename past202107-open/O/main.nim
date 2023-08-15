const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree

type S = int #m: 最大値
type F = tuple[u:bool, d:int] # u: updateされたかどうか, d: 足された数
proc op(a, b:S):S = max(a, b)
proc e():S = -int.inf
proc mapping(f:F, s:S):S =
  if f.u: return -int.inf
  elif s == -int.inf: return -int.inf
  else: return s + f.d
proc composition(f1, f2:F):F =
  if f1.u or f2.u: return (true, 0)
  else: return (false, f1.d + f2.d)
proc id():F = (false, 0)

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var v = 0 & B.sorted
  v = v.deduplicate(isSorted = true)
  var st = initLazySegTree[S, F](v.len, op, e, mapping, composition, id)
  st[0] = 0
  for i in N:
    st.allApply((false, A[i]))
    let
      b = v.lowerBound(B[i])
      m = st[0 ..< b]
    debug m
    st.apply(0 ..< b, (false, 0))
    if m >= B[i]:
      st[b] = max(st[b], m - B[i])
  echo st.allProd()
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
