include atcoder/extra/header/chaemon_header


proc solve(N:int, K:int, a:seq[int]) =
  let M = a.max
  var ct = newSeq[int](M + 1)
  for a in a: ct[a].inc
  var m = K
  var ans = 0
  for t in 0..M:
    let u = min(m, ct[t])
#    debug m, u
    ans += t * (m - u)
    m.min=u
  ans += (M + 1) * m
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
#}}}
