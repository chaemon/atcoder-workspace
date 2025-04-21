when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, c:seq[string], S:string):
  let
    c1 = c[0][0]
    c2 = c[1][0]
  var S = S
  for i in N:
    if S[i] != c1: S[i] = c2
  echo S
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var c = newSeqWith(2, nextString())
  var S = nextString()
  solve(N, c, S)
else:
  discard

