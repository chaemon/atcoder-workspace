when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string, T:string):
  ans := 0
  for i in N:
    ans += (if S[i] == T[i]: 0 else: 1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

