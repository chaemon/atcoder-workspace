when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  ans := 0
  for i in S.len:
    for j in i + 1 ..< S.len:
      let k = j * 2 - i
      if k >= S.len: break
      if S[i] == 'A' and S[j] == 'B' and S[k] == 'C': ans.inc
  echo ans
  doAssert false

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

