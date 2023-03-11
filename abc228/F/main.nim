const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/dp/cumulative_sum_2d
import lib/dp/slide_min

solveProc solve(H:int, W:int, h:seq[int], w:seq[int], A:seq[seq[int]]):
  var
    h = h
    w = w
  h[1] = min(h[1], h[0])
  w[1] = min(w[1], w[0])
  var cs = initCumulativeSum2D[int](H, W)
  for i in H:
    for j in W:
      cs.add(i, j, A[i][j])
  cs.build
  let
    hd = h[0] - h[1] + 1
    wd = w[0] - w[1] + 1
  var t:seq[seq[int]]
  for i in 0 .. H - h[1]:
    var a = Seq[int]
    for j in 0 .. W - w[1]:
      a.add cs[i ..< i + h[1], j ..< j + w[1]]
    t.add slideMax(a, wd)
  for j in t[0].len:
    var a = Seq[int]
    for i in t.len:
      a.add t[i][j]
    a = slideMax(a, hd)
    for i in a.len:
      t[i][j] = a[i]
  var ans = -int.inf
  for i in 0 .. H - h[0]:
    for j in 0 .. W - w[0]:
      ans.max= cs[i ..< i + h[0], j ..< j + w[0]] - t[i][j]
  echo ans
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var h = newSeqWith(2, 0)
  var w = newSeqWith(2, 0)
  for i in 0..<2:
    h[i] = nextInt()
    w[i] = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, h, w, A)
else:
  discard

