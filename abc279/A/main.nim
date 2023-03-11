when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S: string):
  ans := 0
  for s in S:
    if s == 'w': ans += 2
    elif s == 'v': ans += 1
    else: doAssert false
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

