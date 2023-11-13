when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var ans = 0
  for i in S.len:
    for j in i + 1 .. S.len:
      let s = S[i ..< j]
      if s.reversed == s:
        ans.max=s.len
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

