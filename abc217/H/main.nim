const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/structure/splay_tree
import lib/structure/slope_trick
#import lib/structure/generalized_slope_trick

solveProc solve(N:int, T:seq[int], D:seq[int], X:seq[int]):
  var st = initSlopeTrick[int]()
#  var st = initGeneralizedSlopeTrick[int]()
  for i in N * 2 + 10:
    st.add_abs(0)
  for i in N:
    var d = if i == 0: T[i] else: T[i] - T[i - 1]
    st.shift(-d, d)
#    var g = st.like()
    if D[i] == 0:
#      g.add_a_minus_x(X[i])
      st.add_a_minus_x(X[i])
    else:
#      g.add_x_minus_a(X[i])
      st.add_x_minus_a(X[i])
#    st.merge(g)
#    echo st.query()

  let Q = st.query()
  echo Q.min_f
#  let d = T[^1]
#  if Q.rx < -d:
#    echo st.get(d)
#  elif d < Q.lx:
#    echo st.get(d)
#  else:
#    echo Q.min_f
  return

when not DO_TEST:
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    D[i] = nextInt()
    X[i] = nextInt()
  solve(N, T, D, X)
else:
  discard

