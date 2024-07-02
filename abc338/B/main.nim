when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var t = Seq[26: 0]
  for c in S:
    t[c - 'a'].inc
  let m = t.max
  for i in 26:
    if t[i] == m:
      echo 'a' + i
      return
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

