include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, Q:int, T:seq[int], X:seq[int], Y:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, Q, T, X, Y)
#}}}

