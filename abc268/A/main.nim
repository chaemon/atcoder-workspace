when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, C:int, D:int, E:int):
  echo @[A, B, C, D, E].toSet.len
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var E = nextInt()
  solve(A, B, C, D, E)
else:
  discard

