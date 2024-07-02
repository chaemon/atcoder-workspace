when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[string], B:seq[string]):
  for i in N:
    for j in N:
      if A[i][j] != B[i][j]:
        echo i + 1, " ", j + 1;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  var B = newSeqWith(N, nextString())
  solve(N, A, B)
else:
  discard

