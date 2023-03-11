const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(A:seq[int]):
  var ans = int.inf
  # add A[1]
  for d in 0..1:
    A0 := A[0] + d
    for e in 0..1:
      A2 := A[2] + e
      var A1 = A0 + A2
      if A1 mod 2 != 0: continue
      A1.div= 2
      if A1 >= A[1]: ans.min= A1 - A[1] + d + e
  # not add A[1]
  # A[0], A[1], A[2] + d
  block:
    let d = A[1] * 2 - A[0] - A[2]
    if d >= 0: ans.min= d
  echo ans
  return

# input part {{{
when not DO_TEST:
  var A = newSeqWith(3, nextInt())
  solve(A)
#}}}

