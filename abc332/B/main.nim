when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(K:int, G:int, M:int):
  var g, m = 0
  for _ in K:
    if g == G:
      g = 0
    elif m == 0:
      m = M
    else:
      if m <= G - g:
        g += m
        m = 0
      else:
        m -= G - g
        g = G
  echo g, " ", m
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var G = nextInt()
  var M = nextInt()
  solve(K, G, M)
else:
  discard

