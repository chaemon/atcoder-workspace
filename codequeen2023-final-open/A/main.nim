when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, c:string):
  var ans:string
  for s in S:
    ans.add s
    if c[0] == s:
      ans.add s
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  var c = nextString()
  solve(S, c)
else:
  discard

