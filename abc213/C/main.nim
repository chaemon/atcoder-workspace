const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(H:int, W:int, N:int, A:seq[int], B:seq[int]):
  var x, y = newSeq[int]()
  for i in 0..<N:
    x.add A[i]
    y.add B[i]
  x.sort
  y.sort
  x = x.deduplicate(isSorted = true)
  y = y.deduplicate(isSorted = true)
  for i in 0..<N:
    let C = x.lower_bound(A[i]) + 1
    let D = y.lower_bound(B[i]) + 1
    echo C, " ", D
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(H, W, N, A, B)

