const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var v = Seq[int]
  for i in N:
    v.add A[i]
    v.add A[i] + B[i]
  v.sort
  v = v.deduplicate(isSorted=true)
  var cs = initDualCumulativeSum[int](v.len)
  for i in N:
    var
      l = v.lowerBound(A[i])
      r = v.lowerBound(A[i] + B[i])
    cs.add(l..<r, 1)
  var ans = Seq[N + 1: 0]
  for i in v.len - 1:
    ans[cs[i]] += v[i + 1] - v[i]
  echo ans[1..^1].join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

