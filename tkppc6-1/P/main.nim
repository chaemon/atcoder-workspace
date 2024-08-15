when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[string]):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var A = newSeqWith(N-1, 0)
    var B = newSeqWith(N-1, 0)
    var C = newSeqWith(N-1, "")
    for i in 0..<N-1:
      A[i] = nextInt()
      B[i] = nextInt()
      C[i] = nextString()
    solve(N, A, B, C)
else:
  discard

