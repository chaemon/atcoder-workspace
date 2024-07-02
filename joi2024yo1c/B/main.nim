when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int):
  let S = A + B
  if S in 1 .. 9:
    echo 1
  elif S in 10..99:
    echo 2
  elif S in 100..999:
    echo 3
  else:
    echo 4
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

