when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var B:seq[int]
  for i in N:
    B.add A[7 * i ..< 7 * (i + 1)].sum
  echo B.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(7*N, nextInt())
  solve(N, A)
else:
  discard

