const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, D:int, X:seq[int], V:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var D = nextInt()
  var X = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, D, X, V, true)
#}}}

