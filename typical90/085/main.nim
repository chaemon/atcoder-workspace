const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(K:int):
  ans := 0
  for a in 1 .. K:
    if a * a * a > K: break
    for b in a .. K:
      if a * b * b > K: break
      if K mod (a * b) != 0: continue
      ans.inc
  echo ans
  return

when not DO_TEST:
  var K = nextInt()
  solve(K)

