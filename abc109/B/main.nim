const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, W:seq[string]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var W = Seq[N: nextString()]
  solve(N, W, true)
#}}}

