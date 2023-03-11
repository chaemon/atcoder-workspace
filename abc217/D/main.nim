const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/set_map


solveProc solve(L:int, Q:int, c:seq[int], x:seq[int]):
  var st = initSortedSet(int)
  st.insert(0)
  st.insert(L)
  for i in Q:
    if c[i] == 1:
      st.insert x[i]
    else:
      var it = st.lower_bound(x[i])
      var it2 = it.pred
      echo *it - *it2
  return

when not DO_TEST:
  var L = nextInt()
  var Q = nextInt()
  var c = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    c[i] = nextInt()
    x[i] = nextInt()
  solve(L, Q, c, x)
else:
  discard

