include atcoder/extra/header/chaemon_header

proc solve(N:int, K:int, T:seq[seq[int]]) =
  var a = (1..<N).toSeq
  var ans = 0
  while true:
    var s = T[0][a[0]]
    for i in 0..<N - 1:
      s += T[a[i]][a[i + 1]]
    s += T[a[N - 1]][0]
    if s == K: ans.inc
    if not nextPermutation(a):break
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var T = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, K, T)
#}}}
