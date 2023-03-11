const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, T:string):
  var
    (dx, dy) = (1, 0)
    (x, y) = (0, 0)
  for t in T:
    if t == 'S':
      x += dx
      y += dy
    else:
      if (dx, dy) == (1, 0):
        (dx, dy) = (0, -1)
      elif (dx, dy) == (0, -1):
        (dx, dy) = (-1, 0)
      elif (dx, dy) == (-1, 0):
        (dx, dy) = (0, 1)
      elif (dx, dy) == (0, 1):
        (dx, dy) = (1, 0)
  echo x, " ", y
  discard

when not DO_TEST:
  var N = nextInt()
  var T = nextString()
  solve(N, T)
else:
  discard

