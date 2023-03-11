const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(x:seq[int], y:seq[int]):
  proc dist(x, y, a, b:int):int =
    (x - a)^2 + (y - b)^2
  for a in x[0]-10..x[0]+10:
    for b in y[0]-10..y[0]+10:
      ok := true
      for i in 2:
        if dist(x[i], y[i], a, b) != 5: ok = false
      if ok: echo YES;return
  echo NO
  discard

when not DO_TEST:
  var x = newSeqWith(2, 0)
  var y = newSeqWith(2, 0)
  for i in 0..<2:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
else:
  discard

