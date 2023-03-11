const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(S:int, T:int):
  var ans = 0
  for a in 0..S:
    for b in 0..S:
      for c in 0..S:
        if a + b + c <= S and a * b * c <= T: ans.inc
  echo ans
  return

when not DO_TEST:
  var S = nextInt()
  var T = nextInt()
  solve(S, T)

