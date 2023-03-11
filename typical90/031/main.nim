const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, W:seq[int], B:seq[int]):
  var dp = Seq[55, 2510: -1]
  proc calc(w, b:int):int =
    if dp[w][b] != -1: return dp[w][b]
    var a = Seq[int]
    if w >= 1:
      a.add calc(w - 1, b + w)
    if b >= 2:
      for k in 1 .. b div 2:
        a.add calc(w, b - k)
    a.sort
    a = a.deduplicate(isSorted = true)
    i := 0
    while i < a.len:
      if a[i] != i:
        result = i
        break
      i.inc
      if i == a.len: result = a.len
    dp[w][b] = result
  ans := 0
  for i in N:
    ans.xor=calc(W[i], B[i])
  if ans == 0:
    echo "Second"
  else:
    echo "First"
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var W = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, W, B)
#}}}

