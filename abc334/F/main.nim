when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/lazysegtree

op(a, b:float) => a # dummy
e() => float.inf
mapping(f, s:float) => min(f, s)
composition(f1, f2:float) => min(f1, f2)
id() => float.inf

solveProc solve(N:int, K:int, S_X:int, S_Y:int, X:seq[int], Y:seq[int]):
  proc dist(x1, y1, x2, y2:int):float =
    sqrt(float((x1 - x2)^2 + (y1 - y2)^2))
  var
    st = initLazySegTree[float, float](N, op, e, mapping, composition, id)
    S = 0.0
  # st[i + 1]: 家iまでに直線距離分以外に移動する距離
  st.apply(0 ..< K, dist(S_X, S_Y, X[0], Y[0]))
  for i in N - 1:
    # st[i]からst[i + 1 .. i + K]を更新
    var d = dist(S_X, S_Y, X[i], Y[i]) + dist(S_X, S_Y, X[i + 1], Y[i + 1]) - dist(X[i], Y[i], X[i + 1], Y[i + 1])
    let r = min(i + K, N - 1)
    st.apply(i + 1 .. r, st[i] + d)
    S += dist(X[i], Y[i], X[i + 1], Y[i + 1])
  echo S + st[N - 1] + dist(S_X, S_Y, X[N - 1], Y[N - 1])
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S_X = nextInt()
  var S_Y = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, K, S_X, S_Y, X, Y)
else:
  discard

