include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var r = Seq[200: 0]
  for i in N:
    r[A[i] mod 200].inc
  var ans = 0
  for i in 200:
    ans += r[i] * (r[i] - 1) div 2
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

