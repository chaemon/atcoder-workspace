const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import atcoder/lazysegtree
import lib/other/compress

const YES = "Yes"
const NO = "No"

op(a, b:int) => min(a, b)
e() => int.inf
mapping(a, b:int) => min(int.inf, a + b)
composition(a, b:int) => min(int.inf, a + b)
id0() => 0

# Failed to predict input format
proc solve(N:int, L, R:seq[int]):void =
  var c = initCompress[int]()
  c.add(0)
  for i in N:
    c.add(L[i])
    c.add(R[i])
  c.build()
  var v = Seq[c.len: seq[int]]
  for i in N:
    let l = c.id(L[i])
    let r = c.id(R[i])
    v[r].add l
  var st = initLazySegTree(Seq[v.len: 0], op, e, mapping, composition, id0)
  var prev = 0
  for i in v.len:
    for l in v[i]:
      st.apply(0..l, -1)

    #block:
    #  debug i
    #  let v = collect newSeq:
    #    for i in 0..<v.len: st[i]
    #  echo "segment: ", v.join(" ")

    let d = c.val(i) - prev
#    debug d
    st.apply(0..<i, d)

    let p = st.prod(0..<i)
    if p < 0:
      echo NO;return

    prev = c.val(i)
  echo YES
  discard

let T = nextInt()
for _ in T:
  let N = nextInt()
  var L, R = Seq[int]
  for _ in N:
    L.add(nextInt() - 1)
    R.add(nextInt())
  # L ..< R
  solve(N, L, R)
