include atcoder/extra/header/chaemon_header

proc solve(N:int, A:seq[int]) =
  var ans = 0
  for i in 0..<N:
    var s = int.inf
    for j in i..<N:
      s.min=A[j]
      ans.max=(j - i + 1) * s
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}
