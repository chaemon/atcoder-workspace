when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/math/sqrt_int

solveProc solve(N:int):
  for k in 1 .. 10^6:
    if N mod k != 0: continue
    var
      N2 = N div k
      s = 4 * N2 - k * k
    if s < 0 or s mod 3 != 0: continue
    s.div=3
    let t = sqrt_int(s)
    if t * t != s: continue
    let
      u = 3 * t
    for d in [-u, u]:
      let
        y = (- 3 * k + d) div 6
        x = y + k
      if x <= 0 or y <= 0: continue
      echo x, " ", y
      doAssert x > 0 and y > 0 and x^3 - y^3 == N
      return
  echo -1
  discard


when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

