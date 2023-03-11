include atcoder/extra/header/chaemon_header


proc solve(N:int, A:seq[int]) =
  var ans = 0
  var s = 0
  for i in 0..<N:
    ans += A[i] * i - s
    s += A[i]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  A.sort
  solve(N, A)
#}}}
