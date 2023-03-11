when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let N = nextInt()
  ans := 0.0
  for i in N:
    let P, Q = nextInt()
    ans += Q / P
  echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

