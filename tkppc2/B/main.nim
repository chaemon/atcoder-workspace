const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, V:seq[int], T:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var V = newSeqWith(N, 0)
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    V[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, V, T)
#}}}

