when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var ans = '0'.repeat(10)
  for i in 10:
    if (N and (1 shl i)) != 0:
      ans[i] = '1'
  ans.reverse
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

