when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, K:int, U:seq[int], V:seq[int], A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(K, nextInt())
  solve(N, M, K, U, V, A, B)
else:
  discard

