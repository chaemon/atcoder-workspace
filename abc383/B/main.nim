when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, D:int, S:seq[string]):
  ans := -int.inf
  for x in H:
    for y in W:
      if S[x][y] != '.': continue
      for x2 in H:
        for y2 in W:
          if S[x2][y2] != '.': continue
          ct := 0
          for i in H:
            for j in W:
              if S[i][j] == '.' and (abs(i - x) + abs(j - y) <= D or abs(i - x2) + abs(j - y2) <= D): ct.inc
          ans.max=ct
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var D = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, D, S)
else:
  discard

