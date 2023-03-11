const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(S:seq[string]):
  if "H" in S and "2B" in S and "3B" in S and "HR" in S:
    echo YES
  else:
    echo NO
  return

# input part {{{
when not DO_TEST:
  var S = newSeqWith(4, nextString())
  solve(S)
#}}}

