const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/graph/hopcroft_karp

const YES = "Yes"
const NO = "No"

var dir = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

solveProc solve(N:int, T:int, AX:seq[int], AY:seq[int], BX:seq[int], BY:seq[int]):
  var t = initTable[(int, int), int]()
  var g = initHopcroftKarp(N, N)
  for i in N:
    t[(BX[i], BY[i])] = i
  for i in N:
    for (dx, dy) in dir:
      let
        x = AX[i] + dx * T
        y = AY[i] + dy * T
      if (x, y) notin t: continue
      let j = t[(x, y)]
      g.addEdge(i, j)
  let m = g.maximum_matching
  if m.len < N:
    echo NO
  else:
    var D = newSeq[int](N)
    for (i, j) in m:
      for d, (dx, dy) in dir:
        if AX[i] + dx * T == BX[j] and AY[i] + dy * T == BY[j]:
          D[i] = d + 1;break
    echo YES & "\n" & D.join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var T = nextInt()
  var AX = newSeqWith(N, 0)
  var AY = newSeqWith(N, 0)
  for i in 0..<N:
    AX[i] = nextInt()
    AY[i] = nextInt()
  var BX = newSeqWith(N, 0)
  var BY = newSeqWith(N, 0)
  for i in 0..<N:
    BX[i] = nextInt()
    BY[i] = nextInt()
  solve(N, T, AX, AY, BX, BY)
