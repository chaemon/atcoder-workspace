when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/lazysegtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type F = tuple[a, b:mint]
type S = tuple[a, b, c:mint, n:int]


proc op(a, b:S):S = (a.a + b.a, a.b + b.b, a.c + b.c, a.n + b.n)
proc e():S = (mint(0), mint(0), mint(0), 0)
proc mapping(f:F, s:S):S =
  result.a = f.a * s.n + s.a
  result.b = f.b * s.n + s.b
  result.c = s.c + f.a * s.b + f.b * s.a + s.n * f.a * f.b
  result.n = s.n
proc composition(f1, f2:F):F = (f1.a + f2.a, f1.b + f2.b)
proc id():F = (mint(0), mint(0))

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  let A, B = Seq[N: mint(nextInt())]
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    st[i] = (A[i], B[i], A[i] * B[i], 1)
  for _ in Q:
    let t = nextInt()
    let
      l = nextInt() - 1
      r = nextInt()
    case t:
      of 1:
        let x = mint(nextInt())
        st.apply(l ..< r, (x, mint(0)))
      of 2:
        let x = mint(nextInt())
        st.apply(l ..< r, (mint(0), x))
      of 3:
        echo st[l ..< r].c
      else:
        doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

