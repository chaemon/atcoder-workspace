const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format

solveProc solve():
  let N, M = nextInt()
  var B = Seq[N, M: nextInt()]
  for j in M - 1:
    if B[0][j] mod 7 == 0: echo NO;return
    if B[0][j] + 1 != B[0][j+1]: echo NO;return
  for i in N - 1:
    for j in M:
      if B[i][j] + 7 != B[i + 1][j]: echo NO;return
  echo YES
  discard

block main:
  solve()
  discard

