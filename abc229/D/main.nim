const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/cumulative_sum
import lib/other/binary_search

solveProc solve(S:string, K:int):
  var cs = initCumulativeSum[int](S.len)
  for i in S.len:
    if S[i] == '.': cs[i] = 1
    else: cs[i] = 0
  if cs[0 ..< S.len] <= K:
    echo S.len;return
  proc f(l:int):bool =
    if l == S.len + 1: return false
    for i in 0 ..< S.len - l + 1:
      if cs[i ..< i+l] <= K:
        return true
    return false
  echo f.maxRight(K .. S.len)
  return

when not DO_TEST:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  discard

