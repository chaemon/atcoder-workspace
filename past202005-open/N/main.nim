when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/set_map

solveProc solve(N, Q:int, t, x, y:seq[int]):
  Pred x, y
  var
    s = initSortedSet[int]()
    a = (0 ..< N).toSeq
  proc consective_swap(i:int) =
    for j in [i - 1, i, i + 1]:
      if j notin 0 .. N - 2: continue
      if a[j] > a[j + 1]:
        s.excl j
    swap a[i], a[i + 1]
    for j in [i - 1, i, i + 1]:
      if j notin 0 .. N - 2: continue
      if a[j] > a[j + 1]:
        s.incl j
  for q in Q:
    if t[q] == 1:
      consective_swap(x[q])
    elif t[q] == 2:
      # x[q] .. y[q]をソート
      # つまり、x[q] ..< y[q]の元がある限りやる
      while true:
        var it = s.lowerBound(x[q])
        if it == s.end() or *it >= y[q]:
          break
        consective_swap(*it)
    else:
      doAssert false
  echo a.succ.join(" ")
  discard


block:
  var
    N = nextInt()
    Q = nextInt()
    t = newSeqWith(Q, 0)
    x = newSeqWith(Q, 0)
    y = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, Q, t, x, y)
