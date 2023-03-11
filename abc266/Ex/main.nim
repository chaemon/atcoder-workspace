const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree
import lib/structure/segtree_2d

solveProc solve(N: int, T: seq[int], X: seq[int], Y: seq[int], A: seq[int]):
  var st = block:
    var v = @[(0, 0)]
    for i in N:
      v.add (T[i] - Y[i] - X[i], T[i] - Y[i] + X[i])
    initSegTree2D(v, (a, b: int) => max(a, b), () => -int.inf)
  var v = Seq[tuple[Y, x, y, i: int]]
  for i in N:
    v.add (Y[i], T[i] - Y[i] - X[i], T[i] - Y[i] + X[i], i)
  v.sort
  #var ans = 0
  ans := 0
  st.set(0, 0, 0)
  for (Y, x, y, i) in v:
    var u = st.prod(-int.inf .. x, -int.inf .. y)
    if u == -int.inf: continue
    ans.max = u + A[i]
    let p = st.get(x, y)
    st.set(x, y, max(p, u + A[i]))
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    X[i] = nextInt()
    Y[i] = nextInt()
    A[i] = nextInt()
  solve(N, T, X, Y, A)
else:
  discard

