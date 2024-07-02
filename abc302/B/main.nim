when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

var dir = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]

solveProc solve(H:int, W:int, S:seq[string]):
  let s = "snuke"
  var ans:seq[(int, int)]
  proc calc(x, y, d:int):(bool, seq[(int, int)]) =
    var (x, y) = (x, y)
    for k in s.len:
      if x notin 0 ..< H or y notin 0 ..< W: result[0] = false;return
      if S[x][y] != s[k]: result[0] = false;return
      result[1].add (x, y)
      x += dir[d][0]
      y += dir[d][1]
    result[0] = true
    return
  for x in H:
    for y in W:
      for d in dir.len:
        let (r, a) = calc(x, y, d)
        if r:
          for (x, y) in a:
            echo x + 1, " ", y + 1
          return
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

