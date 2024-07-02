when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/lazysegtree

type P = tuple[min, n:int] # minimum, min_count

proc op(a, b:P):P =
  if a.min == b.min:
    return (a.min, a.n + b.n)
  elif a.min < b.min:
    return a
  elif a.min > b.min:
    return b
  else:
    doAssert false
e() => (int.inf, 0)
mapping(f:int, s:P) => (s.min + f, s.n)
composition(f1, f2:int) => f1 + f2
id() => 0

solveProc solve(N:int, A:seq[int]):
  Pred A
  var
    prev, next = Seq[N: int]
  block:
    var appeared = Seq[N: -1]
    for i in N:
      prev[i] = appeared[A[i]]
      appeared[A[i]] = i
  block:
    var appeared = Seq[N: N]
    for i in 0 ..< N << 1:
      next[i] = appeared[A[i]]
      appeared[A[i]] = i
  var
    st = initLazySegTree[P, int](N + 1, op, e, mapping, composition, id)
    v:seq[tuple[x, y0, y1, t: int]]
    vi = 0
    ans = 0
  for i in N:
    # (prev[i] + 1 .. i) ..< (i + 1 .. next[i])の長方形を足す
    # L ..< R
    # Lの範囲: prev[i] + 1 ..< i + 1
    # Rの範囲: i + 1 ..< next[i] + 1
    v.add (prev[i] + 1, i + 1, next[i] + 1,  1)
    v.add (i       + 1, i + 1, next[i] + 1, -1)
  for i in 0 .. N:
    st[i] = (0, 1)
  v.sort
  for x in N:
    while vi < v.len and v[vi].x <= x:
      doAssert v[vi].x == x
      let (x, y0, y1, t) = v[vi]
      st.apply(y0 ..< y1, t)
      vi.inc
    ans += N + 1
    let d = st.allProd()
    if d.min == 0:
      ans -= d.n
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

