const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/dp/dual_cumulative_sum_2d

const B = 1000

solveProc solve(N:int, lx:seq[int], ly:seq[int], rx:seq[int], ry:seq[int]):
  var a = initDualCumulativeSum2D[int](B, B)
  for i in N:
    a.add(lx[i] ..< rx[i], ly[i] ..< ry[i], 1)
  a.build
  ans := Seq[N + 1: 0]
  for i in B:
    for j in B:
      ans[a[i, j]].inc
  ans = ans[1 .. ^1]
  echo ans.join("\n")
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var lx = newSeqWith(N, 0)
  var ly = newSeqWith(N, 0)
  var rx = newSeqWith(N, 0)
  var ry = newSeqWith(N, 0)
  for i in 0..<N:
    lx[i] = nextInt()
    ly[i] = nextInt()
    rx[i] = nextInt()
    ry[i] = nextInt()
  solve(N, lx, ly, rx, ry)
#}}}

