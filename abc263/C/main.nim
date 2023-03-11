const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/algorithmutils

solveProc solve(N:int, M:int):
  var ans = Seq[seq[int]]
  for c in combination((1 .. M).toSeq, N):
    ans.add c
  ans.sort
  for c in ans:
    echo c.join(" ")

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard
