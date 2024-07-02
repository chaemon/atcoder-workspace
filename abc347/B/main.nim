when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var v:seq[string]
  for i in S.len:
    for j in i + 1 .. S.len:
      v.add S[i ..< j]
  echo v.toSet.len
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

