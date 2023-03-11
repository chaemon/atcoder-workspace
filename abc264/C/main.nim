const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve():
  var
    H1, W1 = nextInt()
    A = Seq[H1, W1: nextINt()]
    H2, W2 = nextInt()
    B = Seq[H2, W2: nextINt()]
  for b in 2^H1:
    if b.popCount != H2: continue
    for b2 in 2^W1:
      if b2.popCount != W2: continue
      var V = Seq[H2, W2: int]
      var ci = 0
      for i in H1:
        if b[i] == 0: continue
        var cj = 0
        for j in W1:
          if b2[j] == 0: continue
          V[ci][cj] = A[i][j]
          cj.inc
        ci.inc
      if B == V:
        echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

