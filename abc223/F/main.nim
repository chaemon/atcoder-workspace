const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/lazysegtree

const YES = "Yes"
const NO = "No"

# Failed to predict input format

type F = int
type S = int

proc op(a, b:S):S = min(a, b)
proc e():S = int.inf
proc mapping(f:F, s:S):S = s + f
proc composition(f0, f1:F):F = f0 + f1
proc id():F = 0

solveProc solve():
  let N, Q = nextInt()
  var S = nextString()
  var st = initLazySegTree(N + 1, op, e, mapping, composition, id)
  st[0] = 0
  var s = 0
  for i in N:
    if S[i] == '(':
      s.inc
    else:
      s.dec
    st[i + 1] = s
  for _ in Q:
    let q = nextInt()
    if q == 1:
      var l, r = nextInt()
      l.dec;r.dec
      if S[l] == S[r]: continue
      var d:int
      if S[l] == ')':
        d = 2
      else:
        d = -2
      st.apply(l + 1 .. r, d)
      swap(S[l], S[r])
    else:
      var l, r = nextInt()
      l.dec;r.dec
      var vl = st[l]
      var vr = st[r + 1]
      if vl != vr: echo NO
      else:
        var m = st[l + 1 .. r] - vl
        if m >= 0: echo YES
        else: echo NO
  discard

block main:
  solve()
  discard

