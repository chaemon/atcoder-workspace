include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, A:seq[int], B:seq[int]) =
  var s = 0
  for i in 0..<N: s += A[i] * B[i]
  echo if s == 0: YES else: NO
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}
