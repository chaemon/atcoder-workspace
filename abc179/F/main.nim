include atcoder/extra/header/chaemon_header
import atcoder/extra/structure/universal_segtree
#import atcoder/lazysegtree


import algorithm

let N, Q = nextInt()
var t, x = newSeq[int](Q)
for i in 0..<Q:
  t[i] = nextInt()
  x[i] = nextInt() - 2

#proc naive() =
#  var xs, ys = newSeq[int]()
#  for q in 0..<Q:
#    if t[q] == 1:
#      ys.add(x[q])
#    else:
#      xs.add(x[q])
#  xs = xs.toSeq().mapIt(it).sorted
#  ys = ys.toSeq().mapIt(it).sorted
#  xs.add(N - 2)
#  ys.add(N - 2)
#  var a = Seq(xs.len, ys.len, false)
#  for i in 0..<a.len:
#    a[i][^1] = true
#  for i in 0..<a[0].len:
#    a[^1][i] = true
#  var ans = 0
#  for q in 0..<Q:
#    if t[q] == 1:
#      let y = ys.binarySearch(x[q])
#      for i in 0..<a.len:
#        if a[i][y]:
#          dump(xs[i])
#          ans += xs[i]
#          break
#        a[i][y] = true
#
#    else:
#      let x = xs.binarySearch(x[q])
#      for i in 0..<a[x].len:
#        if a[x][i]:
#          dump(ys[i])
#          ans += ys[i]
#          break
#        a[x][i] = true
#  echo (N - 2)^2 - ans
#
#naive()

proc main() =
#  var st0, st1 = initlazySegTree(N, (a:int,b:int)=>min(a,b), ()=>int.inf, (a:int, b:int)=>min(a, b), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var st0 = initDualSegTree[int](newSeqWith(N - 2, N - 2), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var st1 = initDualSegTree[int](newSeqWith(N - 2, N - 2), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var a, b = N - 2
  var ans = (N - 2)^2
  for q in 0..<Q:
    if t[q] == 1:
      if x[q] < b:
        b = x[q]
        ans -= a
        st0.apply(0..<a, b)
      elif x[q] > b:
        let t = st1.get(x[q])
        ans -= t
      else:
        assert false
    else:
      if x[q] < a:
        a = x[q]
        ans -= b
        st1.apply(0..<b, a)
      elif x[q] > a:
        let t = st0.get(x[q])
        ans -= t
      else:
        assert false
  echo ans
  return

main()

