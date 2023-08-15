when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(a:int, b:int, c:int):
  var
    a = float(a)
    b = float(b)
    c = float(c)
  proc f(x:float):float = 
    a * x^5 + b * x + c
  if f(1.0) > 0.0:
    a *= -1
    b *= -1
    c *= -1
  var
    l = 1.0
    r = 2.0
  while r - l > 1e-10:
    let m = (l + r) * 0.5
    if f(m) < 0.0:
      l = m
    else:
      r = m
  echo l
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  solve(a, b, c)
else:
  discard

