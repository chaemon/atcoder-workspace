include atcoder/extra/header/chaemon_header

import atcoder/segtree

proc solve(N:int, a:seq[int]) =
  st := initSegTree(N, (a, b:int) => a + b, () => 0)
  var s = 0
  for i in 0..<N:
    s += st[a[i] ..< N]
    st.set(a[i], st[a[i]] + 1)
  for i in 0..<N:
    echo s
    s += (N - 1 - a[i]) - (a[i])
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1-0+1, nextInt())
  solve(N, a)
#}}}
