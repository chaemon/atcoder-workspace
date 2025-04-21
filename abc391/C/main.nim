when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  var
    ct = Seq[N: 1]
    pos = (0 ..< N).toSeq
    u = 0
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let P, H = nextInt() - 1
      ct[pos[P]].dec
      if ct[pos[P]] == 1: u.dec
      pos[P] = H
      ct[pos[P]].inc
      if ct[pos[P]] == 2: u.inc
    else:
      echo u
  doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

