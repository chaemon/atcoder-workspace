const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree

type S = int # 最大値
type F = int # intで置き換える

op(a, b:S) => max(a, b)
e() => 0
mapping(f:F, s:S) => (if f == -1: s else: f)
composition(f1, f2:F) => (if f1 == -1: f2 else: f1)
id() => -1

solveProc solve(W:int, N:int, L:seq[int], R:seq[int]):
  Pred L
  var st = initLazySegTree[int, int](W, op, e, mapping, composition, id)
  for i in N:
    let M = st.prod(L[i] ..< R[i])
    echo M + 1
    #block:
    #  data := Seq[int]
    #  for j in W:
    #    data.add st[j]
    st.apply(L[i] ..< R[i], M + 1)
  return

# input part {{{
when not DO_TEST:
  var W = nextInt()
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(W, N, L, R)
#}}}

