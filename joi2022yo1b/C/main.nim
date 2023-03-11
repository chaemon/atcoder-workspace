const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, S:string):
  for i in 0..<N-1:
    if S[i + 1] == 'J':
      echo S[i]
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

