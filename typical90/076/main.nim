const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, A:seq[int]):
  var s0 = A.sum
  if s0 mod 10 != 0:
    echo NO;return
  s0.div=10
  var
    s = 0 # i ..< jでのsの和 s <= s0を保つ
    j = 0
  for i in N:
    while j < N and s < s0:
      s += A[j]
    s -= A[i]
  echo YES
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
