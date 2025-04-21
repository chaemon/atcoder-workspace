when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(D:int):
  var
    x = 0
    ans = int.inf
  while true:
    let p = D - x^2
    if p < 0:
      ans.min=abs(p)
      break
    # y^2 <= p < (y + 1)^2
    let y = int(sqrt(float(p))+1e-9)
    doAssert y^2 <= p and p < (y + 1)^2
    ans.min=p - y^2
    ans.min=(y + 1)^2 - p
    x.inc
  echo ans
  discard

when not defined(DO_TEST):
  var D = nextInt()
  solve(D)
else:
  discard

