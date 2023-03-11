const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import lib/graph/graph_template
import lib/other/direction

import lib/graph/dijkstra

let H, W = nextInt()

let S = Seq[H:nextString()]

#iterator adj_iter(a:(int, int)):((int, int), int) {.closure.} =
#  let (x, y) = a
#  for (x2, y2) in (x, y).neighbor(dir4):
#    if x2 notin 0..<H or y2 notin 0..<W: continue
#    if S[x2][y2] == '#': continue
#    debug (x2, y2)
#    yield ((x2, y2), 0)
#  for i in -2 .. 2:
#    debug i
#    let x2 = x + i
#    for j in -2 .. 2:
#      let y2 = y + j
#      if x2 notin 0..<H: continue
#      if y2 notin 0..<W: continue
#      if i.abs == 2 and j.abs == 2: continue
#      yield ((x2, y2), 1)
##      echo (x, y), " -> ", (x2, y2)

proc adj_iter(a:(int, int)):seq[((int, int), int)] =
  let (x, y) = a
  for (x2, y2) in (x, y).neighbor(dir4):
    if x2 notin 0..<H or y2 notin 0..<W: continue
    if S[x2][y2] == '#': continue
    result.add ((x2, y2), 0)
  for i in -2 .. 2:
    let x2 = x + i
    if x2 notin 0..<H: continue
    for j in -2 .. 2:
      let y2 = y + j
      if y2 notin 0..<W: continue
      if i.abs == 2 and j.abs == 2: continue
      result.add ((x2, y2), 1)
#      echo (x, y), " -> ", (x2, y2)


var g = initGraph(H * W, (a:(int, int)) => a[0] * W + a[1], adj_iter)

var dist = g.dijkstra((0, 0))

echo dist[(H - 1, W - 1)]

