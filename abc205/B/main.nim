include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

solveProc solve(N:int, A:seq[int]):
  var A = sorted(A)
  for i in 0..<N:
    if A[i] != i + 1: echo NO;return
  echo YES
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A, true)
#}}}

