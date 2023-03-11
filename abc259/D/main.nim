const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, s_x:int, s_y:int, t_x:int, t_y:int, x:seq[int], y:seq[int], r:seq[int]):
  var d = initDSU(N + 2)
  for i in N:
    for j in i + 1 ..< N:
      let d2 = (x[i] - x[j])^2 + (y[i] - y[j])^2
      if d2 in (r[i] - r[j])^2 .. (r[i] + r[j])^2:
        d.merge(i, j)
  for i in N:
    if r[i]^2 == (x[i] - s_x)^2 + (y[i] - s_y)^2: d.merge(N, i)
    if r[i]^2 == (x[i] - t_x)^2 + (y[i] - t_y)^2: d.merge(N + 1, i)
  if d.leader(N) == d.leader(N + 1):
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var s_x = nextInt()
  var s_y = nextInt()
  var t_x = nextInt()
  var t_y = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    r[i] = nextInt()
  solve(N, s_x, s_y, t_x, t_y, x, y, r)
else:
  discard

