include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, a:seq[int]) =
  let S = a.sum
  let P = S div 2
  let a = a & a
  ans := int.inf
  s := 0
  i := 0
  for l in 0..<N:
    while i < a.len and s < P: s += a[i]; i.inc
    ans.min= abs(s - (S - s))
    s -= a[l]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
#}}}

