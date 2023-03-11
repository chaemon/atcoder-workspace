include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(A:seq[int]) =
  var A = A
  A.sort
  if A[0] - A[1] == A[1] - A[2]: echo YES
  else: echo NO
  return

# input part {{{
block:
  var A = newSeqWith(3, nextInt())
  solve(A)
#}}}

