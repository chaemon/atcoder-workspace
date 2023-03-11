when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, S: string):
  var
    x = 1
    ans = 0
  for s in S:
    if s == 'L':
      x = x - 1
    elif s == 'R':
      x = x + 1
    x = x.clamp(1, 3)
    if x == 3: ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

