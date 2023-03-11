when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string):
  var S = S
  i := 0
  while i < N:
    if i + 1 < N and S[i] == S[i + 1]:
      if S[i] == 'j':
        S[i] = 'J'
        S[i + 1] = 'J'
      elif S[i] == 'o':
        S[i] = 'O'
        S[i + 1] = 'O'
      elif S[i] == 'i':
        S[i] = 'I'
        S[i + 1] = 'I'
      i += 2
    else:
      i += 1
  echo S
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

