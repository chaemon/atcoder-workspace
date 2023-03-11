include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree
import atcoder/extra/dp/cumulative_sum

const DEBUG = true

e() => -int.inf
op(a, b:int) => max(a, b)
mapping(a, b:int) => a + b
composition(a, b:int) => a + b
id() => 0

# Failed to predict input format
block main:
  let N, M = nextInt()
  let a = Seq[N: nextInt()]
  var cs = initCumulativeSum(N, int)
  for i in 0..<N:cs[i] = a[i]
  var st = initLazySegTree(N + 1, op, e, mapping, composition, id)
  st[0] = 0
  var b = Seq[N: seq[tuple[l, c:int]]]
  var x = Seq[N + 1: int]
  x[0] = 0
  for i in 0..<M:
    let l, r = nextInt() - 1
    let c = nextInt()
    b[r].add((l, c))
  for r in 0..<N:
    x[r + 1] = max(x[r], st[r])
    st.apply(0..r, a[r])
    v := 0
    for (l, c) in b[r]:
      v.max= st[l..r] - c
      v.max= cs[l..r] - c + x[l]
    st[r + 1] = v
  echo max(st[N], x[N])
