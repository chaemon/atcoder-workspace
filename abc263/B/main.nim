const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int]):
  var P = @[-1, -1] & P
  var
    i = N
    c = 0
  while i != 1:
    i = P[i]
    c.inc
  echo c
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  solve(N, P)
else:
  discard

