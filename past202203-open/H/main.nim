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
    a = N @ seq[int]
    leader = N @ int
  for i in N:
    a[i] = @[i]
    leader[i] = i
  for _ in Q:
    let t = nextInt()
    if t == 1:
      var
        u , v = nextInt() - 1
      while leader[u] != u:
        u = leader[u]
      while leader[v] != v:
        v = leader[v]
      if u == v: continue
      if a[u].len <= a[v].len:
        leader[u] = v
        for t in a[u]:
          a[v].add t
      else:
        leader[v] = u
        for t in a[v]:
          a[u].add t
    elif t == 2:
      var u = nextInt() - 1
      while leader[u] != u:
        u = leader[u]
      a[u].sort()
      echo a[u].succ.join(" ")
  discard

when not DO_TEST:
  solve()
else:
  discard

