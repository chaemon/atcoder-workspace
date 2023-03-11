const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, W:int, A:seq[int], B:seq[int]):
  var v = Seq[(int, int)]
  for i in N: v.add (A[i], B[i])
  v.sort(SortOrder.Descending)
  var
    W = W
    ans = 0
  for (A, B) in v:
    if W >= B:
      ans += A * B
      W -= B
    else:
      ans += A * W
      break
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var W = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, W, A, B)
else:
  discard

