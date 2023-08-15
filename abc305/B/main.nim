when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(p:string, q:string):
  var d = [3, 1, 4, 1, 5, 9, 2]
  proc pos(c:char):int =
    let i = c - 'A'
    return d[0 ..< i].sum
  echo abs(pos(q[0]) - pos(p[0]))
  discard

when not defined(DO_TEST):
  var p = nextString()
  var q = nextString()
  solve(p, q)
else:
  discard

