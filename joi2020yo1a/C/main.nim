include atcoder/extra/header/chaemon_header


proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  let C = sorted(A & B)
  for c in C:
    echo c
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
#}}}
