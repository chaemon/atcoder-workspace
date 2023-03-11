when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let N, Q = nextInt()
  var P = -1 & Seq[N - 1: nextInt() - 1]
  var deg = Seq[N: 0]
  for u in 1 ..< N:
    deg[P[u]].inc
  for _ in Q:
    var M = nextINt()
    var v = Seq[M: nextInt() - 1]
    var s = v.toSet
    # vが表
    var
      c = 0 # 表の親が表のもの
      d = 0
      ans = 0
    for u in v:
      d += deg[u]
      if u == 0: ans.inc
      else:
        if P[u] in s:
          c.inc
        else:
          ans.inc
    ans += d - c
    echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

