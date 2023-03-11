include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  a := Seq[1000: false]
  let m = A.max
  let M = B.min
  if m > M: echo 0
  else: echo M - m + 1
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}

