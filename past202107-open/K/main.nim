const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, A:seq[int], U:seq[int], V:seq[int], T:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  var T = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, A, U, V, T)
#}}}

