when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/sqrt_int

solveProc solve(R:int):
  var
    ans = 0
  for y in 0 ..< R:
    # (x + 1/2, y + 1/2)が円に内包するようなxの最大値
    # (x + 1/2)^2 + (y + 1/2)^2 <= R^2
    # つまり(2x + 1)^2 <= 4 R^2 - (2y+1)^2
    let u = sqrtInt(4 * R^2 - (2 * y + 1)^2)
    # 2x + 1 <= uである
    let xmax = (u - 1) div 2
    if y == 0:
      ans += xmax * 2 + 1
    else:
      ans += (xmax * 2 + 1) * 2
  echo ans
  doAssert false

when not defined(DO_TEST):
  var R = nextInt()
  solve(R)
else:
  discard

