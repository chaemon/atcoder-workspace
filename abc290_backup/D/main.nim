when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/set_map

# Failed to predict input format
solveProc solve():
  let N, D, K = nextInt()
  var s = initSortedSet[int]() # 印が付いていないマス
  for i in N:
    s.insert(i)
  ans := Seq[int]
  var A = 0
  s.erase(A)
  ans.add A
  for _ in N - 1:
    var x = (A + D) mod N
    var it = s.lowerBound(x)
    if it != s.end():
      A = *it
    else:
      it = s.lowerBound(-1)
      A = *it
    ans.add A
    s.erase(A)
  echo ans[K - 1]
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    solve()
else:
  discard

