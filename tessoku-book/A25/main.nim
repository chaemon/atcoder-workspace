when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, c:seq[string]):
  var dp = Seq[H, W: 0]
  dp[0][0] = 1
  for i in H:
    for j in W:
      if c[i][j] == '#': continue
      if i + 1 < H and c[i + 1][j] != '#':
        dp[i + 1][j] += dp[i][j]
      if j + 1 < W and c[i][j + 1] != '#':
        dp[i][j + 1] += dp[i][j]
  echo dp[H - 1][W - 1]
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var c = newSeqWith(H, nextString())
  solve(H, W, c)
else:
  discard

