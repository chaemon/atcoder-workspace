const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(M, nextInt())
  var D = newSeqWith(M, nextInt())
  solve(N, M, A, B, C, D)
else:
  discard

