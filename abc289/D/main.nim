when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, A:seq[int], M:int, B:seq[int], X:int):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  var X = nextInt()
  solve(N, A, M, B, X)
else:
  discard

