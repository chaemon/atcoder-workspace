const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const NO = "NO"

solveProc solve(A:seq[seq[int]]):
  return

when not DO_TEST:
  var A = newSeqWith(3, newSeqWith(3, nextInt()))
  solve(A)
else:
  discard

