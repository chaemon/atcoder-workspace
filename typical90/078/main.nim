const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int], b:seq[int]):
  Pred a, b
  var adj = Seq[N: seq[int]]
  for i in M:
    adj[a[i]].add b[i]
    adj[b[i]].add a[i]
  ans := 0
  for u in N:
    cnt := 0
    for v in adj[u]:
      if v < u: cnt.inc
    if cnt == 1:
      ans.inc
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
#}}}

