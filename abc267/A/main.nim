const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

var a = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

solveProc solve(S:string):
  for i in a.len:
    if S == a[i]:
      echo a.len - i;return
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

