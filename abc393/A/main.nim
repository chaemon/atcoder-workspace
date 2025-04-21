when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:seq[string]):
  if S[0] == "sick":
    if S[1] == "sick":
      echo 1
    else:
      echo 2
  else:
    if S[1] == "sick":
      echo 3
    else:
      echo 4
  doAssert false

when not defined(DO_TEST):
  var S = newSeqWith(2, nextString())
  solve(S)
else:
  discard

