when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/lazysegtree

type P = tuple[l0, l1, r0, r1, m0, m1, len:int]

proc op(a, b:P):P =
  result = (l0:a.l0, l1:a.l1, r0: b.r0, r1:b.r1, m0:max(a.m0, b.m0), m1:max(a.m1, b.m1), len: a.len + b.len)
  if a.l0 == a.len: result.l0 += b.l0
  if a.l1 == a.len: result.l1 += b.l1
  if b.r0 == b.len: result.r0 += a.r0
  if b.r1 == b.len: result.r1 += a.r1
  if a.r0 >= 0 and b.l0 >= 0: result.m0.max=a.r0 + b.l0
  if a.r1 >= 0 and b.l1 >= 0: result.m1.max=a.r1 + b.l1

proc e():P = (l0: 0, l1: 0, r0: 0, r1: 0, m0: 0, m1: 0, len: 0)

proc mapping(f:bool, p:P):P =
  if not f: return p
  result = p
  swap result.l0, result.l1
  swap result.r0, result.r1
  swap result.m0, result.m1

proc composition(f1, f2:bool):bool = f1 xor f2

proc id():bool = false

solveProc solve():
  var
    N, Q = nextInt()
    S = nextString()
  var st = initLazySegTree[P, bool](N, op, e, mapping, composition, id)
  for i in N:
    if S[i] == '0':
      st[i] = (l0: 1, l1: 0, r0: 1, r1: 0, m0: 1, m1: 0, len: 1)
    elif S[i] == '1':
      st[i] = (l0: 0, l1: 1, r0: 0, r1: 1, m0: 0, m1: 1, len: 1)
  for _ in Q:
    var c, L, R = nextInt()
    L.dec # L ..< R
    if c == 1:
      st.apply(L ..< R, true)
    elif c == 2:
      echo st[L ..< R].m1

solve()
