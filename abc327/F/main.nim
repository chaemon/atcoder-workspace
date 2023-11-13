when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/lazysegtree

type
  S = int
  F = int

op(s, t: S) => max(s, t)
e() => 0
mapping(f: F, s: S) => s + f
composition(f1, f2:F) => f1 + f2
id() => 0

solveProc solve(N:int, D:int, W:int, T:seq[int], X:seq[int]):
  var
    st = initLazySegTree[S, F](2 * 10^5 + 10, op, e, mapping, composition, id)
    q = Seq[tuple[t, d, l, r: int]]
  # d = 1: 時刻tにl ..< rの値に1を足す
  # d = -1: 時刻tにl ..< rの値に1を引く
  for i in N:
    # S ..< S + Dに
    # L <= X[i] < L + W
    # つまり、X[i] - W < L <= X[i]であればよい
    # X[i] - W + 1 <= L < X[i] + 1
    let l = max(X[i] - W + 1, 0)
    q.add (T[i], 1, l, X[i] + 1)
    q.add (T[i] + D, -1, l, X[i] + 1)
  q.sort
  var
    i = 0
    ans = -int.inf
  while i < q.len:
    var j = i
    while j < q.len and q[j].t == q[i].t:
      let (t, d, l, r) = q[j]
      st.apply(l ..< r, d)
      j.inc
    ans.max=st.allProd()
    i = j
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var W = nextInt()
  var T = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    X[i] = nextInt()
  solve(N, D, W, T, X)
else:
  discard

