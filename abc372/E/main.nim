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
    a = Seq[N: seq[int]]
    top = Seq[N: seq[int]]
    leader = (0 ..< N).toSeq
  for i in N:
    a[i] = @[i]
    top[i] = @[i]
  for _ in Q:
    let
      t = nextInt()
    if t == 1:
      var
        u, v = nextInt() - 1
        ui = leader[u]
        vi = leader[v]
      if ui != vi:
        if a[ui].len < a[vi].len:
          swap u, v
          swap ui, vi
        for i in a[vi]:
          leader[i] = ui
        a[ui].add a[vi]
        top[ui].add top[vi]
        top[ui].sort(Descending)
        if top[ui].len >= 10:
          top[ui].setLen 10
        top[vi].setLen(0)
    else:
      let v, k = nextInt() - 1
      if top[leader[v]].len <= k:
        echo -1
      else:
        echo top[leader[v]][k] + 1
  discard

when not DO_TEST:
  solve()
else:
  discard

