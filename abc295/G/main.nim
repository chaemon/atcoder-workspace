when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var
    p = Seq[N - 1: nextInt() - 1]
    rev_p = Seq[N: -1]
  p = -1 & p
  for u in 1 ..< N:
    rev_p[p[u]] = u
  var dsu = initDSU(N)
  proc merge_dsu(u, v:int) =
    discard
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

