when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

#import atcoder/maxflow
import lib/graph/maxflow_lowerbound

const YES = "Yes"
const NO = "No"

solveProc solve(H:int, W:int, c:seq[string]):
  var g = initMaxFlowLowerBound[int](H * W + 4)
  s := H * W
  t := s + 1
  s0 := t + 1
  t0 := s0 + 1
  id := Seq[H, W: int]
  id_now := 0
  g.addEdge(s, s0, 0, int.inf)
  g.addEdge(t0, t, 0, int.inf)
  for x in H:
    for y in W:
      if (x + y) mod 2 == 0:
        id[x][y] = id_now
        id_now.inc
        g.addEdge(s, id[x][y], 1, 1)
  let ct = id_now
  for x in H:
    for y in W:
      if (x + y) mod 2 == 1:
        id[x][y] = id_now
        id_now.inc
        g.addEdge(id[x][y], t, 1, 1)
  for x in H:
    for y in W:
      # (x, y)から隣接点へ
      if (x + y) mod 2 == 0:
        if c[x][y] in ['?', '2']:
          for (x2, y2) in [(x + 1, y), (x, y + 1), (x - 1, y), (x, y - 1)]:
            if x2 notin 0 ..< H or y2 notin 0 ..< W: continue
            if c[x2][y2] == '1': continue
            g.addEdge(id[x][y], id[x2][y2], 0, 1)
        if c[x][y] in ['?', '1']:
          g.addEdge(id[x][y], t0, 0, 1)
      else: # (x + y) mod 2 == 1
        if c[x][y] in ['?', '1']:
          g.addEdge(s0, id[x][y], 0, 1)
  let r = g.can_flow(s, t)
  if r:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var c = newSeqWith(H, nextString())
  solve(H, W, c)
else:
  discard

