when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int, D:int):
  var
    x = A
    ans:seq[int]
  while true:
    ans.add x
    if x == B: break
    x += D
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var D = nextInt()
  solve(A, B, D)
else:
  discard

