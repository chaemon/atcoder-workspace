const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/set_map


solveProc solve(N:int, Q:int, A:seq[int], L:seq[int], R:seq[int], X:seq[int]):
  var st = initSortedMultiSet(uint, countable=true)
  for u in A: st.insert(u.uint)
  for i in Q:
    let bi = st.lower_bound(L[i].uint)
    let ei = st.lower_bound((R[i] + 1).uint)
    let ct = distance(bi, ei)
    var ans = 0.uint
#    for it in bi..<ei:
#      ans.xor= *it
#      var it2 = it
#      st.erase(it2)
#    var it = bi
#    while it != ei:
#      ans.xor= *it
#      var it2 = it
#      it.inc
#      st.erase(it2)
    echo ans.int
    if ct mod 2 == 1: st.insert(X[i].uint)
  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  var X = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
    X[i] = nextInt()
  solve(N, Q, A, L, R, X)
else:
  discard

