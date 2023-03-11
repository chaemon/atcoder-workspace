const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(P:seq[int]):
  var ans = ""
  for i in P:
    ans.add(chr('a'.ord + i))
  echo ans
  return

when not DO_TEST:
  var P = newSeqWith(26, nextInt() - 1)
  solve(P)
else:
  discard

