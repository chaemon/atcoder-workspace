include atcoder/header
import atcoder/extra/structure/universal_segtree

const N = 10
var st = initDualSegTree(N, (a:int, b:int)=>min(a, b), ()=>1111)

st.apply(0..3, 3)

for i in 0..<N:
  echo st.get(i)
