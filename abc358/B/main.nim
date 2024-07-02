when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, T:seq[int]):
  var t = 0
  for i in N:
    t.max=T[i]
    t += A
    echo t
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, A, T)
else:
  discard

