const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int):
  var ans:seq[int]
  for d in 1..N:
    if d * d > N: break
    if N mod d == 0:
      ans.add d
      let d2 = N div d
      if d2 > d:
        ans.add d2
  ans.sort
  echo ans.join("\n")
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

