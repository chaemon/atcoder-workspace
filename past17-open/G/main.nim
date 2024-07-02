when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

var dir = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]

const YES = "Yes"
const NO = "No"
solveProc solve(H:int, W:int, G:seq[string], N:int, S:string):
  var
    vis:seq[seq[bool]]
    found = false
  proc f(i, x, y:int) =
    if i == N:
      found = true;return
    else:
      if G[x][y] != S[i]: return
      vis[x][y] = true
      for (dx, dy) in dir:
        let
          x2 = x + dx
          y2 = y + dy
        if x2 notin 0 ..< H or y2 notin 0 ..< W or vis[x2][y2]: continue
        f(i + 1, x2, y2)
        if found: return
      vis[x][y] = false
  for x in H:
    for y in W:
      vis = Seq[H, W: false]
      f(0, x, y)
      if found: break
    if found: break
  if found:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var G = newSeqWith(H, nextString())
  var N = nextInt()
  var S = nextString()
  solve(H, W, G, N, S)
else:
  discard

