when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var v:seq[int]
  block:
    var N = N - 1
    while N > 0:
      v.add N mod 5
      N.div=5
  v.reverse
  for i in v.len: v[i] *= 2
  echo v.join("")
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

