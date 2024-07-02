when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, T:seq[int]):
  Pred T
  var a = Seq[N: true]
  for i in Q:
    if a[T[i]]:
      a[T[i]] = false
    else:
      a[T[i]] = true
  echo a.count(true)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var T = newSeqWith(Q, nextInt())
  solve(N, Q, T)
else:
  discard

