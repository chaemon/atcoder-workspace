const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, A:int, X:int, Y:int):
  var s = 0
  for i in 0..<N:
    if i < A:
      s += X
    else:
      s += Y
  echo s
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var X = nextInt()
  var Y = nextInt()
  solve(N, A, X, Y)
#}}}

