const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const NO = "Impossible"

solveProc solve(N:int, S:int, A:seq[int], B:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, S, A, B)
#}}}

