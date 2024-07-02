when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  ans := 0
  for i in N:
    case S[i]
    of 'j':
      ans += 2
    of 'o':
      ans += 1
    of 'i':
      ans += 2
    else:
      discard
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

