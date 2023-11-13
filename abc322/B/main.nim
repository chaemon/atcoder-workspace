when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, S:string, T:string):
  var s, p = false
  if S == T[0 ..< N]:
    p = true
  if S == T[^N .. ^1]:
    s = true
  if s and p:
    echo 0
  elif p:
    echo 1
  elif s:
    echo 2
  else:
    echo 3
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, M, S, T)
else:
  discard

