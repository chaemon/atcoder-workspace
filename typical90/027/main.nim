const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  a := initSet[string]()
  for i,s in S:
    if s notin a:
      echo i + 1
      a.incl(s)
  return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
