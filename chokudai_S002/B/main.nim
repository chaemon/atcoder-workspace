include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  for i in N:
    echo A[i] mod B[i]
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}

