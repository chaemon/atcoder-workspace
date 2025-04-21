when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string, T:string):
  var a, b = 0
  for i in N:
    let (s, t) = (S[i], T[i])
    if s != t:
      if s == 'R' and t == 'S': a.inc
      elif s == 'S' and t == 'P': a.inc
      elif s == 'P' and t == 'R': a.inc
      else: b.inc
  echo a, " ", b
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

