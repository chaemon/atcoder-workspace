const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
#import atcoder/lazysegtree
import lib/structure/universal_segtree

type S = tuple[a: array[3, int], b: array[3, array[3, int]]] # 0, 1, 2の数と転倒数
type F = array[3, int]

proc op(a, b:S):S =
  for i in 3:
    result.a[i] = a.a[i] + b.a[i]
  for i in 3:
    for j in 3:
      result.b[i][j] += a.b[i][j]
      result.b[i][j] += b.b[i][j]
      result.b[i][j] += a.a[i] * b.a[j]

proc e():S =
  discard

proc mapping(f:F, s:S):S =
  for i in 3:
    result.a[f[i]] += s.a[i]
  for i in 3:
    for j in 3:
      result.b[f[i]][f[j]] += s.b[i][j]

proc composition(f1, f2:F):F =
  for i in 3:
    result[i] = f1[f2[i]]

proc id():F =
  [0, 1, 2]

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var A = Seq[N: nextInt()]
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    var s: S
    s.a[A[i]] = 1
    st[i] = s
  for _ in Q:
    let t = nextInt()
    if t == 1:
      var L, R = nextInt()
      L.dec
      var u = st[L ..< R]
      ans := 0
      for i in 0 .. 2:
        for j in 0 ..< i:
          ans += u.b[i][j]
      echo ans
    else:
      var L, R, S, T, U = nextInt()
      L.dec
      st.apply(L ..< R, [S, T, U])
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

