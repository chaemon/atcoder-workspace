const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  var l, m, r:seq[int]
  for i in N:
    if S[i] == 'L':
      r.add i
    else:
      l.add i
  r.reverse
  echo (l & N & r).join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

