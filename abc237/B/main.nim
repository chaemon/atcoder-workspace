const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, A:seq[seq[int]]):
  var B = Seq[W, H: int]
  for i in H:
    for j in W:
      B[j][i] = A[i][j]
  for j in W:
    echo B[j].join(" ")
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
else:
  discard

