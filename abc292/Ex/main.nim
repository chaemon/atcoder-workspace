when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree
import lib/forward_compatibility/internal_sugar

type S = tuple[s, m:int] # 合計値と合計の最大値
proc op(a, b:S):S =
  (a.s + b.s, max(a.m, a.s + b.m))
proc e():S = (0, -int.inf)

solveProc solve(N:int, B:int, Q:int, a:seq[int], c:seq[int], x:seq[int]):
  # 各回のレートはa - Bとする。この合計が正になるとレート変化はしない
  Pred c
  st := initSegTree[S](N, op, e)
  for i in N:
    let t = a[i] - B
    st[i] = (t, t)
  for q in Q:
    let t = x[q] - B
    st[c[q]] = (t, t)
    proc f(a:S):bool =
      a.m < 0
    let r = st.maxRight(0, f)
    var u = min(N, r + 1)
    let a = st[0 ..< u]
    doAssert u == N or (a.m >= 0 and a.m == a.s)
    let S = a.s + B * u
    echo S / u
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var B = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N, nextInt())
  var c = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    c[i] = nextInt()
    x[i] = nextInt()
  solve(N, B, Q, a, c, x)
else:
  discard

