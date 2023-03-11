const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/slope_trick_generalized

# Failed to predict input format

solveProc solve():
  var st = initGeneralizedSlopeTrick[int]()
  let Q = nextInt()
  for _ in Q:
    let q = nextInt()
    if q == 1:
      let a, b = nextInt()
      st.add_abs(a)
      st.add_all(b)
    else:
      let t = st.query()
      echo t.lx, " ", t.min_f
  discard

block main:
  solve()
  discard

