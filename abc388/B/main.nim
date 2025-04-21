when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:int, T:seq[int], L:seq[int]):
  for k in 1 .. D:
    var a:seq[int]
    for i in N:
      a.add T[i] * (L[i] + k)
    echo a.max
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var T = newSeqWith(N, 0)
  var L = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    L[i] = nextInt()
  solve(N, D, T, L)
else:
  discard

