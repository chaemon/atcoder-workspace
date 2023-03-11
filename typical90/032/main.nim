const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, A:seq[seq[int]], M:int, X:seq[int], Y:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, A, M, X, Y)
#}}}

