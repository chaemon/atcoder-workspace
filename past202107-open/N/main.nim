const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree

type S = tuple[w, b:int]
type F = bool

proc op(a, b:S):S = (a.w + b.w, a.b + b.b)
proc e():S = (0, 0)
proc mapping(f:F, s:S):S =
  if not f: s
  else: (s.b, s.w)
proc composition(f1, f2:F):F = f1 xor f2
proc id():F = false

solveProc solve(Q:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  var xs:seq[int]
  for q in Q:
    xs.add A[q]
    xs.add C[q]
  xs.sort
  xs = xs.deduplicate(isSorted = true)
  var qs:seq[tuple[y, t, l, r:int]]
  for q in Q:
    let
      a = xs.lowerBound(A[q])
      c = xs.lowerBound(C[q])
    qs.add (B[q], 1, a, c)
    qs.add (D[q], -1, a, c)
  qs.sort()
  var
    st = initLazySegTree[S, F](xs.len - 1, op, e, mapping, composition, id)
    ans = 0
  for i in xs.len - 1:
    let d = xs[i + 1] - xs[i]
    st[i] = (d, 0)
  var i = 0
  while i < qs.len:
    var j = i
    while j < qs.len and qs[j].y == qs[i].y:
      st.apply(qs[j].l ..< qs[j].r, true)
      j.inc
    if j == qs.len: break
    let dy = qs[j].y - qs[i].y
    ans += st.allProd().b * dy
    i = j
  echo ans
  return

when not DO_TEST:
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(Q, A, B, C, D)
