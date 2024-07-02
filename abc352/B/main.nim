when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, T:string):
  var
    i = 0
    j = 0
    ans:seq[int]
  while i < S.len:
    while S[i] != T[j]:
      j.inc
    ans.add j + 1
    i.inc
    j.inc
  echo ans.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

