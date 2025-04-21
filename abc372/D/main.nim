when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/structure/set_map
import lib/dp/dual_cumulative_sum

solveProc solve(N:int, H:seq[int]):
  var
    s = initSortedSet[int]()
    a:seq[tuple[H, i:int]]
    t = initDualCumulativeSum[int](N)
  for i in N:
    a.add (H[i], i)
  a.sort(SortOrder.Descending)
  for (H, i) in a:
    # prev ..< iが対象範囲
    var
      prev: int
      it = s.lowerBound(i) # i以上のインデックス
    if it == s.begin():
      prev = 0
    else:
      var it2 = it
      it2.dec
      prev = *it2
    t.add(prev ..< i, 1)
    s.incl i
  var ans = Seq[N: 0]
  for i in N:
    ans[i] = t[i]
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
else:
  discard

