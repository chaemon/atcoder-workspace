const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, A:seq[int]):
  S := 0
  for i in N:
    if i mod 2 == 1: S += A[i] - 1
    else: S += A[i]
  if S <= X: echo YES
  else: echo NO
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
#}}}

