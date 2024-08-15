const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

# 1 -> 0
# 2 -> 1
# 3 -> 1
#

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  proc calc(X:seq[int]):int =
    let
      X = X.sorted
      x = X[(X.len) div 2]
    result = 0
    for i in X.len:
      result += abs(X[i] - x)
  echo calc(X) + calc(Y)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
#}}}

