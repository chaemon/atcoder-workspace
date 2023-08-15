when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  let
    A = S.count('A')
    T = S.count('T')
  if A > T:
    echo "A"
  elif A < T:
    echo "T"
  else:
    if S[^1] == 'T':
      echo "A"
    else:
      echo "T"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

