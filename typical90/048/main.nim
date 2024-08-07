const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  var v:seq[int]
  for i in N:
    v.add B[i]
    v.add A[i] - B[i]
  v.sort(SortOrder.Descending)
  echo v[0 ..< K].sum
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, K, A, B)
