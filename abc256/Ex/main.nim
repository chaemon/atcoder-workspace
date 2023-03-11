const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/universal_segtree

const B = 10^5 + 10

var fail_ct = 0

type F = object
  x, y:int
  # yにupdate,  y = -1なら何もしない
  # その後xで割る


type S = object
  fail: bool
  all, s, n: int
proc op(l, r:S):S =
  doAssert not l.fail and not r.fail
  result.fail = false
  result.n = l.n + r.n
  result.s = l.s + r.s
  if l.all >= 0 and r.all >= 0 and l.all == r.all:
    result.all = l.all
  else:
    result.all = -1

proc e():S =
  S(fail:false, all: 0, s: 0, n: 1)

proc mapping(f:F, s:S):S =
  if f.y >= 0:
    let t = f.y div f.x
    return S(fail: false, all: t, s: t * s.n, n: s.n)
  elif f.x == 1:
    return s
  elif s.all == -1:
    # f.y == -1
    fail_ct.inc
    return S(fail: true)
  # s.all >= 0
  let y = s.all div f.x
  return S(fail: false, all: y, s: y * s.n, n: s.n)

proc composition(f, g:F):F =
  if f.y >= 0:
    return f
  else:
    result = g
    result.x *= f.x
    result.x.min= B

proc id():F =
  F(x:1, y: -1)

# Failed to predict input format
solveProc solve(N, Q:int, a:seq[int]):
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    st[i] = S(fail: false, all: a[i], s: a[i], n: 1)
  for q in Q:
    let t = nextInt()
    var L, R = nextInt()
    L.dec
    # L ..< R
    if t == 1:
      let x = nextInt()
      st.apply(L ..< R, F(x: x, y: -1))
    elif t == 2:
      let y = nextInt()
      st.apply(L ..< R, F(x: 1, y: y))
    else:
      echo st[L ..< R].s

when not DO_TEST:
  let
    N, Q = nextInt()
    a = Seq[N: nextInt()]
  solve(N, Q, a)
else:
  let N, Q = 10^5
  var
    st = initLazySegTree(N, op, e, mapping, composition, id)
    a = (1 .. N).toSeq
  for i in N:
    debug i, fail_ct
    st[i] = S(fail: false, all: a[i], s: a[i], n: 1)
