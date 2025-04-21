when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/lazysegtree
import sugar

type S = seq[int]
type F = int

let N, D = nextInt()
var shift = 0
proc op(a, b:S):S =
  result = collect(newSeq):
    for i in D: a[i] xor b[i]
proc e():S = Seq[D: 0]
proc mapping(f:F, s:S):S = s[f .. ^1] & s[0 ..< f]
proc composition(f1, f2:F):F =
  result = f1 + f2
  if result >= D: result -= D
  doAssert result in 0 ..< D
proc id():F = 0

# Failed to predict input format
solveProc solve():
  var
    A = Seq[N: nextInt()]
    st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  let P = 10^(D - 1)
  for i in N:
    var
      a, d:seq[int]
      A0 = A[i]
      x = A[i]
    for j in D:
      d.add A0 mod 10
      A0.div=10
    for j in D:
      a.add x
      x -= d[D - 1 - j] * P
      x *= 10
      x += d[D - 1 - j]
    st[i] = a
  let Q = nextInt()
  for _ in Q:
    let t = nextInt()
    case t
    of 1:
      shift += nextInt()
      if shift >= N: shift -= N
    of 2:
      var l, r, y = nextInt()
      l.dec
      l += shift
      r += shift
      if l >= N:
        l -= N
        r -= N
      doAssert l in 0 ..< N
      if N <= r:
        st.apply(l ..< N, y)
        st.apply(0 ..< r - N, y)
      else:
        st.apply(l ..< r, y)
    of 3:
      var l, r = nextInt()
      l.dec
      l += shift
      r += shift
      if l >= N:
        l -= N
        r -= N
      var ans: S
      doAssert l in 0 ..< N
      if N <= r:
        ans = op(st[l ..< N], st[0 ..< r - N])
      else:
        ans = st[l ..< r]
      echo ans[0]
    else:
      doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

