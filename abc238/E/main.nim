const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var (l, r) = unzip(Q, (nextInt() - 1, nextInt()))
  var d = initDSU(N + 1)
  for i in Q:
    d.merge(l[i], r[i])
  if d.same(0, N):
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  solve()
else:
  discard

