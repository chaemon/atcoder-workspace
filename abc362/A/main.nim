when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(R:int, G:int, B:int, C:string):
  if C[0] == 'R':
    echo min(G, B)
  elif C[0] == 'G':
    echo min(R, B)
  else:
    echo min(R, G)
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var G = nextInt()
  var B = nextInt()
  var C = nextString()
  solve(R, G, B, C)
else:
  discard

