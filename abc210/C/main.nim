const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

include atcoder/extra/structure/set_map

solveProc solve(N:int, K:int, c:seq[int]):
  var a = initSortedMap(int, int)
#  var a = initTable[int, int]()
  for i in K:
    a[c[i]] += 1
  var ans = -int.inf
  for i in 0..<N - K + 1:
    ans.max=a.len
    a[c[i]] -= 1
    if a[c[i]] == 0:
      a.erase(c[i])
    if i + K < N:
      var t = a[c[i + K]]
      a[c[i + K]] = t + 1
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var c = newSeqWith(N, nextInt())
  solve(N, K, c)
#}}}

