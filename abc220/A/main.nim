const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(A:int, B:int, C:int):
  for n in A..B:
    if n mod C == 0: echo n;return
  echo -1
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
else:
  discard

