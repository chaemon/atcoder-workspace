include atcoder/extra/header/chaemon_header

proc solve() =
  let N = nextInt()
  let A = newSeqWith(N, nextInt())
  var ans = 0
  var p = 0
  var s = 0
  var partial_max = 0
  for i in 0..<N:
    ans.max= p + partial_max
    s += A[i]
    partial_max.max=s
    p += s
  ans.max= p
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
