const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import complex

solveProc solve(a:int, b:int, d:int):
  var (r, theta) = polar(complex(a.float, b.float))
  theta += d / 180 * PI
  let p = rect(r, theta)
  echo p.re, " ", p.im
  discard

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  var d = nextInt()
  solve(a, b, d)
else:
  discard

