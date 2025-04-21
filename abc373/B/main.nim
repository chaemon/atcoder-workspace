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
    p = -1
    x = 0
    ans = 0
  for i in 26:
    let c = 'A' + i
    for j in 26:
      if S[j] == c:
        if p != -1:
          ans += abs(p - j)
        p = j
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

