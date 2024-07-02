when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:int, M:int, L:int):
  ans := int.inf
  for s in 0 .. N:
    for m in 0 .. N:
      for l in 0 .. N:
        let d = 6 * s + 8 * m + 12 * l
        if d < N: continue
        ans.min= s * S + m * M + l * L
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var M = nextInt()
  var L = nextInt()
  solve(N, S, M, L)
else:
  discard

