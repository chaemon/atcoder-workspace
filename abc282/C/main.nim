when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  S := S
  c := 0
  for i in N:
    if S[i] == '"':
      c.inc
    elif S[i] == ',':
      if c mod 2 == 0:
        S[i] = '.'
  echo S
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

