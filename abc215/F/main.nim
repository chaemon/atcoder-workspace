const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, x:seq[int], y:seq[int]):
  var (x, y) = (x, y)
  var p = Seq[tuple[x, y:int]]
  for i in N: p.add((x[i], y[i]))
  p.sort
  for i in N:
    x[i] = p[i].x
    y[i] = p[i].y
  proc f(M:int):bool =
    var
      l = 0
      empty = true
      ymin = int.inf
      ymax = -int.inf
    for i in N:
      while true:
        if l < N and x[l] <= x[i] - M:
          ymin.min=y[l]
          ymax.max=y[l]
          empty = false
          l.inc
        else:
          break
      var d = -int.inf
      if not empty: d.max= abs(y[i] - ymin)
      if not empty: d.max= abs(y[i] - ymax)
      if d >= M: return true
    return false
  echo f.maxRight(0..2 * 10^9)
  return

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
else:
  discard

