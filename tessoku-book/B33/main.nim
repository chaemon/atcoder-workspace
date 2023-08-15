when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:int, W:int, A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, H, W, A, B)
else:
  discard

