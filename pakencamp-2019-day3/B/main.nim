when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  b := 0
  w := 0
  for i in N:
    if S[i] == "black":
      b.inc
    elif S[i] == "white":
      w.inc
  if b > w:
    echo "black"
  else:
    echo "white"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

