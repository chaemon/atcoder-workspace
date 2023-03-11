include atcoder/extra/header/chaemon_header

import atcoder/fenwicktree

type xint = distinct int
`+`(x, y:xint) => x.int xor y.int
proc `+=`(x:var xint, y:xint) =
  x = (x.int xor y.int).xint
`-`(x, y:xint) => x.int xor y.int

proc solve() =
  let N, Q = nextInt()
  let A = Seq(N, nextInt())
  var st = getFenwickTreeType(xint).init(N)
  for i in 0..<N:
    st.add(i, A[i].xint)
  for i in 0..<Q:
    var T, X, Y = nextInt()
    if T == 1:
      X.dec
      st.add(X, Y.xint)
    else:
      X.dec
      Y.dec
      echo st.sum(X..Y).int
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
