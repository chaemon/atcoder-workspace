when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/lazysegtree

type S = tuple[len: int32, a:array[11, int32]]
type F = int32

proc op(a, b:S):S =
  result.len = a.len + b.len
  for i in 0 .. 10:
    result.a[i] = a.a[i] + b.a[i]
proc e():S = result
proc mapping(f:F, s:S):S =
  if f == -1: return s
  else:
    result.len = s.len
    result.a[f] = s.len
proc composition(f1, f2:F):F =
  if f1 == -1: return f2
  else: return f1
proc id():F = -1

solveProc solve():
  let N, Q = nextInt()
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    let A = nextInt()
    var s:S
    s.len = 1
    s.a[A] = 1
    st[i] = s
  for _ in Q:
    var
      C = nextInt()
      L = nextInt() - 1
      R = nextInt()
    # L ..< R
    var s = st[L ..< R]
    if C == 1:
      var
        p = L
      for i in 0 .. 10:
        var p2 = p + s.a[i]
        st.apply(p ..< p2, i)
        p = p2
    elif C == 2:
      var
        p = L
      for i in 0 .. 10 << 1:
        var p2 = p + s.a[i]
        st.apply(p ..< p2, i)
        p = p2
    else:
      var ans = 0
      for i in 0 .. 10:
        ans += i * s.a[i]
      echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

