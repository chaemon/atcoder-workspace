const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/extra/structure/slope_trick_generalized

solveProc solve(N:int, l:seq[int], r:seq[int]):
  var st = initGeneralizedSlopeTrick[int]()
  for i in 0..<N:
    if i > 0:
      let d = r[i] - l[i]
      let d_prev = r[i - 1] - l[i - 1]
      st.shift(-d, d_prev)
    st.addAbs(l[i])
  echo st.query().min_f
  return

when not DO_TEST:
  var N = nextInt()
  var l = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  for i in 0..<N:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, l, r)
else:
  discard

