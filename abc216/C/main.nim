const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

solveProc solve(N:int):
  var ans = ""
  var N = N
  while N > 0:
    if N mod 2 == 1:
      ans.add 'A'
      N.dec
    N.div= 2
    ans.add 'B'
  ans.reverse
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)

