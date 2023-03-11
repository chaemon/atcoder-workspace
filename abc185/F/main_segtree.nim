include atcoder/extra/header/chaemon_header

#import atcoder/segtree
include atcoder/segtree

proc solve() =
  let N, Q = nextInt()
  let A = Seq(N, nextInt())
  f(x, y:int) => x xor y
  id() => 0
  var st = SegTreeType(int, f, id).init(N)
  for i in 0..<N:
    st.set(i, A[i])
  for i in 0..<Q:
    var T, X, Y = nextInt()
    if T == 1:
      X.dec
      st.set(X, st.get(X) xor Y)
    else:
      X.dec
      Y.dec
      echo st.prod(X..Y)
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
