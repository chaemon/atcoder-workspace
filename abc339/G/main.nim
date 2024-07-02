when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/extra/structure/segtree_2d

op(a, b:int) => a + b
e() => 0

# Failed to predict input format
solveProc solve():
  var v:seq[(int, int)]
  let
    N = nextInt()
    A = Seq[N: nextInt()]
  for i in N:
    v.add (i, A[i])
  var
    st = initSegtree2D[int](v, op, e)
    B = 0
  for i in N:
    st.add(i, A[i], A[i])
  let Q = nextInt()
  for _ in Q:
    var alpha, beta, gamma = nextInt()
    let
      L = alpha xor B
      R = beta xor B
      X = gamma xor B
    doAssert L in 1 .. N and R in 1 .. N and L <= R
    doAssert X in 0 .. 10^9
    #debug L, R, X
    # L - 1 ..< R
    B = st.prod(L - 1 ..< R, 0 .. X)
    echo B
  discard

when not DO_TEST:
  solve()
else:
  discard

