include atcoder/extra/header/chaemon_header

proc solve(N:int, M:int, A:seq[int]) =
  B := Seq(M + 1, 0)
  for i in 0..<N:
    B[A[i]].inc
  echo B.max
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
#}}}
