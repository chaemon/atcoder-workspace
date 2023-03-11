include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var ans = 0
  for a in A:
    if a <= 10: continue
    ans += a - 10
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

