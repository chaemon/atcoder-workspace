when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int):
  var ans = 0
  for a in 1..N:
    for b in 1..N:
      let c = K - a - b
      if c in 1 .. N:
        ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

