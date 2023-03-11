include atcoder/extra/header/chaemon_header


proc solve(N:int, A:seq[int]) =
  let m = A.max
  var i = 0
  while A[i] != m: i.inc
  echo A[0..<i].sum
  echo A[i+1..<N].sum
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}
