const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(A:seq[seq[int]]):
  var ans = 0
  for b in 2^16:
    var B = Seq[4, 4:0]
    for i in 4:
      for j in 4:
        if b[i * 4 + j] == 1: B[i][j] = 1
    var ok = true
    for i in 4:
      for j in 4:
        if A[i][j] == 1 and B[i][j] == 0:
          ok = false
    if not ok: continue
    var vis = Seq[4, 4:

  return

when not DO_TEST:
  var A = newSeqWith(4, newSeqWith(4, nextInt()))
  solve(A)
else:
  discard

