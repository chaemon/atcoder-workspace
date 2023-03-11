const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(H:int, W:int, A:seq[seq[int]], B:seq[seq[int]]):
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  var B = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A, B)
#}}}

