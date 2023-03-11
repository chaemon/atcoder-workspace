const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search

solveProc solve(N:int, L:int, K:int, A:seq[int]):
  var A = A
  A.add L
  proc f(l:int):bool =
    var prev = 0
    var ct = 0
    for i in 0..<A.len:
      if A[i] - prev >= l:
        ct.inc
        prev = A[i]
        if ct == K + 1: return true
    return false
  echo f.maxRight(1..L)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, K, A)
#}}}

