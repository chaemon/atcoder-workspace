const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/compress
import atcoder/lazysegtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type S = tuple[s, a:mint]
type F = tuple[z:bool, d:mint]

op(a, b:S) => (a.s + b.s, a.a + b.a)
e() => (mint(0), mint(0))
mapping(f:F, s:S) => (if f.z: (s.s, f.d * s.s) else: (s.s, s.a + f.d * s.s))
composition(f1, f2:F) => (if f1.z: f1 else: (f2.z, f1.d + f2.d))
id() => (false, mint(0))

solveProc solve(N:int, Q:int, D:seq[int], L:seq[int], R:seq[int]):
  var c = initCompress[int](L, R)
  var st = initLazySegTree[S, F](c.len - 1, op, e, mapping, composition, id)
  for i in c.len - 1:
    let
      l = c[i]
      r = c[i + 1]
      s = (mint(l) + mint(r - 1)) * mint(r - l) / 2
    st[i] = (s, mint(0))
  st.apply(0 .. ^1, (false, mint(D[0])))
  for i in Q:
    let
      li = c.id(L[i])
      ri = c.id(R[i])
    echo st[li ..< ri].a
    st.apply(li ..< ri, (true, mint(0)))
    if i == Q - 1: break
    st.apply(0 .. ^1, (false, mint(D[i + 1] - D[i])))
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var D = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    D[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt() + 1
  solve(N, Q, D, L, R)
else:
  discard

