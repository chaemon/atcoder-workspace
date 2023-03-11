when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var a = Seq[N: seq[int]]
  for i in N:
    let L = nextInt()
    for j in L:
      a[i].add nextInt()
  for _ in Q:
    let s, t = nextInt() - 1
    echo a[s][t]
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

