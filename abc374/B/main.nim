when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, T:string):
  if S == T:
    echo 0
  else:
    var i = 0
    while true:
      if S.len == i or T.len == i or S[i] != T[i]:
        echo i + 1
        break
      i.inc
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

