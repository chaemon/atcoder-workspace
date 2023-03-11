const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, Q:int, A:seq[int], T:seq[int], x:seq[int], y:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var T = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, Q, A, T, x, y)
#}}}

