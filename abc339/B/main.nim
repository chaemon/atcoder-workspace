when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

var dir = [(-1, 0), (0, 1), (1, 0), (0, -1)]

solveProc solve(H:int, W:int, N:int):
  var
    ans = Seq[H: '.'.repeat(W)]
    d = 0
    x = 0
    y = 0
  for i in N:
    if ans[x][y] == '.':
      ans[x][y] = '#'
      d = (d + 1).floorMod(4)
    else:
      ans[x][y] = '.'
      d = (d - 1).floorMod(4)
    x = (x + dir[d][0]).floorMod H
    y = (y + dir[d][1]).floorMod W
  for i in H:
    echo ans[i]
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  solve(H, W, N)
else:
  discard

