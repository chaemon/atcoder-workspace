const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int):
  var N = N
  var v = newSeq[int]()
  while N > 0:
    v.add N mod 10
    N = N div 10
  var ans = -int.inf
  for b in 1..<2^v.len - 1:
    var x, y = newSeq[int]()
    for i in 0..<v.len:
      if b[i]:
        x.add v[i]
      else:
        y.add v[i]
    x.sort(SortOrder.Descending)
    y.sort(SortOrder.Descending)
    if x[0] == 0 or y[0] == 0: continue
    var p, q = 0
    for i in 0..<x.len:
      p *= 10
      p += x[i]
    for i in 0..<y.len:
      q *= 10
      q += y[i]
    ans.max=p * q
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

