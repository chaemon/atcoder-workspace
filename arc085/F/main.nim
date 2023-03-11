include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree
import atcoder/extra/dp/cumulative_sum

const DEBUG = true

e() => int.inf
op(a, b:int) => min(a, b)
mapping(a, b:int) => min(int.inf, a + b)
composition(a, b:int) => a + b
id() => 0

proc solve(N:int, b:seq[int], Q:int, l:seq[int], r:seq[int]) =
  var st = initLazySegTree(N + 1, op, e, mapping, composition, id)
  st[0] = int.inf
  var a = Seq[N: seq[int]]
  var x = Seq[N + 1: int]
  var cs = initCumulativeSum(N, int)
  for i in 0..<N: cs[i] = b[i]
  x[0] = 0
  for i in 0..<Q: a[r[i]].add(l[i])
  for r in 0..<N:
    echo "r = ", r
    for i in 0..r:
      stdout.write st[i], " "
    echo ""
    var t = min(x[r], st[r])
    if b[r] == 1: t.inc
    x[r + 1] = t
    if b[r] == 0: st.apply(0..r, 1)
    v := int.inf
    for l in a[r]:
      debug l, r, r - l + 1 - cs[l..r] + x[l]
      v.min= st[l..r]
      v.min= r - l + 1 - cs[l..r] + x[l]
    debug v
    st[r + 1] = v
  debug x
  echo min(st[N], x[N])
  return

# input part {{{
block:
  var N = nextInt()
  var b = newSeqWith(N, nextInt())
  var Q = nextInt()
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt() - 1
    r[i] = nextInt() - 1
  solve(N, b, Q, l, r)
#}}}

