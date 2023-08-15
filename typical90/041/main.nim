const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/geometry/geometry_template
import lib/geometry/polygon

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  var p: Polygon[float]
  for i in N:
    p.add initPoint[float](X[i], Y[i])
  var
    ch = convexHull(p)
    ch_i:seq[(int, int)]
    S2 = 0
  for p in ch:
    ch_i.add (int(p.re + 0.5), int(p.im + 0.5))
  for i in 1 .. ch_i.len - 2:
    let
      j = i + 1
      x1 = ch_i[i][0] - ch_i[0][0]
      y1 = ch_i[i][1] - ch_i[0][1]
      x2 = ch_i[j][0] - ch_i[0][0]
      y2 = ch_i[j][1] - ch_i[0][1]
    S2 += abs(x1 * y2 - y1 * x2)
  #let S2 = int(ch.area * 2.0 + 0.5)
  var b = 0
  for i in ch_i.len:
    let
      j = (i + 1) mod ch_i.len
      dx = ch_i[i][0] - ch_i[j][0]
      dy = ch_i[i][1] - ch_i[j][1]
      g = gcd(dx, dy)
    b += g
  var i = S2 - b + 2
  doAssert i mod 2 == 0
  i = i div 2
  echo i + b - N
  return

when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
