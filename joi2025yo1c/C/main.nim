when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, B:int):
  ans := 0
  for n in 1 .. N:
    ct := 0
    if n mod A == 0: ct.inc
    if n mod B == 0: ct.inc
    if ct == 1:
       ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  discard

