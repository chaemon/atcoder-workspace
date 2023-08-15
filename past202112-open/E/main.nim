when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:string):
  var
    p = N[0]
    ans = 500
  for i in 1 ..< N.len:
    if p == N[i]:
      ans += 301
    else:
      if p in '1' .. '5':
        if N[i] in '1' .. '5':
          ans += 210
        else:
          ans += 100
      else:
        if N[i] notin '1' .. '5':
          ans += 210
        else:
          ans += 100
    p = N[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextString()
  solve(N)
else:
  discard

