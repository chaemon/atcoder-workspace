const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(S:seq[string]):
  for c in ["ABC", "ARC", "AGC", "AHC"]:
    if c notin S:
      echo c
      return
  return

when not DO_TEST:
  var S = newSeqWith(3, nextString())
  solve(S)
else:
  discard

