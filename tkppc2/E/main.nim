const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, X:seq[int], V:seq[int], Q:int, T:seq[int], L:seq[int], R:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    V[i] = nextInt()
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, X, V, Q, T, L, R)
#}}}

