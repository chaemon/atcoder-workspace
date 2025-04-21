when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, a:seq[int]):
  var a = a.sorted
  s := 0
  ct := 0
  for i in N:
    if s < a[i]:
      s += a[i]
      ct += 1
  echo ct
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

