const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


solveProc solve(N:int, K:int, a:seq[int]):
  let q = K div N
  let r = K mod N
  var v = newSeq[(int, int)]()
  var ans = Seq[N: q]
  for i in N: v.add((a[i], i))
  v.sort()
  for i in r:
    ans[v[i][1]].inc
  echo ans.join("\n")
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
#}}}

