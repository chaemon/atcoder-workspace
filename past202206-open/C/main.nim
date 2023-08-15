when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int):
  var
    ans = ""
    p = 1
  for _ in M:
    p *= N
    if p <= 10^9:
      ans.add 'o'
    else:
      ans.add 'x'
      p = 10^9 + 1
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

