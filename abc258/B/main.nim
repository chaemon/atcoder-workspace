const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

var d = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]

solveProc solve(N:int, A:seq[string]):
  ans := -int.inf
  for x in N:
    for y in N:
      for (dx, dy) in d:
        var
          (x, y) = (x, y)
          s = 0
        for i in N:
          s *= 10
          s += A[x][y].ord - '0'.ord
          x += dx
          y += dy
          x = x.floorMod N
          y = y.floorMod N
        ans.max= s
  echo ans

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  solve(N, A)
else:
  discard

