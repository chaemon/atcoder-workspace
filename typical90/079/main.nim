const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(H:int, W:int, A:seq[seq[int]], B:seq[seq[int]]):
  var
    A = A
    ct = 0
  for i in H - 1:
    for j in W - 1:
      let d = B[i][j] - A[i][j]
      # A[i .. i + 1][j .. j + 1]の値をd足す
      ct += abs(d)
      for i2 in i .. i + 1:
        for j2 in j .. j + 1:
          A[i2][j2] += d
  if A != B:
    echo NO
  else:
    echo YES
    echo ct
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  var B = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A, B)

