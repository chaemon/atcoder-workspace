const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, K:int, A:int):
  var A = A
  for i in 0..<K:
    if i == K - 1: break
    A.inc
    if A > N: A = 1
  echo A
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = nextInt()
  solve(N, K, A)
else:
  discard

