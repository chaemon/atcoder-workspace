include atcoder/extra/header/chaemon_header

proc solve(N:int, a:seq[int], b:seq[int]) =
  var amax = -int.inf
  var ans = -int.inf
  for i in 0..<N:
    amax.max=a[i]
    ans.max=amax * b[i]
    echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  solve(N, a, b)
#}}}
