include atcoder/extra/header/chaemon_header

var N:int
var K:int
var P:seq[int]
var C:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  P = newSeqWith(N, nextInt() - 1)
  C = newSeqWith(N, nextInt())
#}}}

proc calc(v:seq[int]):int =
  let vmax = v.max
  if vmax < 0:
    return vmax
  var max_score = Seq(v.len + 1, -int.inf)
  max_score[0] = 0
  for i in 0..<v.len:
    var 
      s = 0
      j = i
      l = 0
    while true:
      s += v[j]
      l.inc
      max_score[l].max=s
      j.inc
      if j == v.len: j = 0
      if j == i:
        assert l == v.len
        break
  var ans = 0
  let s = v.sum
  for l in 0..v.len:
    if l > K: continue
    if s <= 0:
      ans.max=max_score[l]
    else:
      let q = (K - l) div v.len
      ans.max= max_score[l] + q * s
  return ans

proc main() =
  var
    vis = Seq(N, false)
    ans = -int.inf
  for u in 0..<N:
    if vis[u]: continue
    var v = newSeq[int]()
    var u2 = u
    while true:
      vis[u2] = true
      v.add(C[u2])
      u2 = P[u2]
      if u == u2: break
    ans.max=calc(v)
  print ans
  return

main()

