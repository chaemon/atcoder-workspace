const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int):
  if N == 0:
    echo "0000"
  elif N < 10:
    echo "000" & $N
  elif N < 100:
    echo "00" & $N
  elif N < 1000:
    echo "0" & $N
  else:
    echo N
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

