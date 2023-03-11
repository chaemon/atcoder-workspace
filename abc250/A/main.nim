const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(H:int, W:int, R:int, C:int):
  var ans = 0
  for i in 1..H:
    for j in 1..W:
      if abs(i - R) + abs(j - C) == 1: ans.inc
  echo ans
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var R = nextInt()
  var C = nextInt()
  solve(H, W, R, C)
else:
  discard

