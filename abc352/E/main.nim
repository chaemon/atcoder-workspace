when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/dsu

# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var v = Seq[tuple[C:int, a:seq[int]]]
  for i in M:
    let K, C = nextInt()
    var a = Seq[K: nextInt() - 1]
    v.add (C, a)
  v.sort
  var
    d = initDSU(N)
    ans = 0
  for (C, a) in v:
    for i in a.len - 1:
      if d.leader(a[i]) != d.leader(a[i + 1]):
        d.merge(a[i], a[i + 1])
        ans += C
  if d.groups().len >= 2:
    echo -1
  else:
    echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

