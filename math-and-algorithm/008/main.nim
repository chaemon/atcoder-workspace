const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:int):
  ans := 0
  for a in 1..N:
    for b in 1..N:
      if a + b <= S: ans.inc
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  solve(N, S)
else:
  discard

