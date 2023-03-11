const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

solveProc solve(A:int, B:int):
  echo A xor B
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
