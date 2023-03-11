when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int):
  var a = Seq[N + 1: 0]
  for A in 1 .. N:
    for B in 1 .. N:
      let P = A * B
      if P > N: break
      a[P].inc
  ans := 0
  for s in 1 ..< N:
    let t = N - s
    ans += a[s] * a[t]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

