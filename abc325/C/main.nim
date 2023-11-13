when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(H:int, W:int, S:seq[string]):
  proc id(x, y:int):int = x * W + y
  var d = initDSU(H * W)
  for x in H:
    for y in W:
      if S[x][y] != '#': continue
      for (dx, dy) in [(0, 1), (1, 0), (1, -1), (1, 1)]:
        let
          x2 = x + dx
          y2 = y + dy
        if x2 in 0 ..< H and y2 in 0 ..< W and S[x2][y2] == '#':
          d.merge(id(x, y), id(x2, y2))
  var
    vis = Seq[H * W: false]
    ans = 0
  for x in H:
    for y in W:
      if S[x][y] == '#':
        let i = d.leader(id(x, y))
        if vis[i]: continue
        vis[i] = true
        ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

