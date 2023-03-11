include atcoder/extra/header/chaemon_header


proc solve(N:int, A:seq[int], B:seq[int]) =
  var s = 0
  for i in 0..<N:
    s += (A[i] + B[i]) * (B[i] - A[i] + 1) div 2
  echo s
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
