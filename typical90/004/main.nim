const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(H:int, W:int, A:seq[seq[int]]):
  var row = Seq[H: 0]
  var col = Seq[W: 0]
  for i in H:
    for j in W:
      row[i] += A[i][j]
      col[j] += A[i][j]
  var B = Seq[H, W:int]
  for i in H:
    for j in W:
      B[i][j] = row[i] + col[j] - A[i][j]
  for i in H:
    echo B[i].join(" ")
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
#}}}

