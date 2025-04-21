when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var
    A:seq[int]
    i = 1
    ct = 0
  while i < S.len:
    if S[i] == '|':
      A.add ct
      ct = 0
    else:
      ct.inc
    i.inc
  echo A.join(" ")
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

