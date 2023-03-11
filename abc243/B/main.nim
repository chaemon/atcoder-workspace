const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int], B:seq[int]):
  var
    s = B.toSet
    h = 0
    b = 0
  for i in N:
    if A[i] == B[i]: h.inc
    elif A[i] in s: b.inc
  echo h
  echo b
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

