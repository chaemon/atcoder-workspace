when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int]):
  var
    ct = 0
    a = 0
    i = 0
  while i < N:
    if a + A[i] <= K:
      a += A[i]
      i.inc
    else:
      ct.inc
      a = 0
  if a > 0:
    ct.inc
  echo ct
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

