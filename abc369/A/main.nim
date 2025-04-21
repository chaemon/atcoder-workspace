when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int):
  ans := 0
  for x in - 1000 .. 1000:
    var v = @[A, B, x].sorted
    if v[1] - v[0] == v[2] - v[1]:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

