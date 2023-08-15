when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  var
    v:seq[int]
    t:int
  for i in N:
    if S[i] == '|':
      v.add i
    elif S[i] == '*':
      t = i
  if t in v[0] .. v[1]:
    echo "in"
  else:
    echo "out"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

