const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import heapqueue

solveProc solve(N:int, K:int, t:seq[int], y:seq[int]):
  var
    s = 0
    q = initHeapQueue[int]() # 負の数のうち無視する分。溢れたら大きい順に取り出す
    qs = 0
    K = K
    ans = -int.inf
  for i in countdown(N - 1, 0):
    let (t, y) = (t[i], y[i])
    if t == 1:
      ans.max= y + s - qs
      K.dec
      if K < 0: break
    else:
      s += y
      if y < 0:
        qs += y
        q.push(-y)
    while q.len > K:
      let y = -q.pop()
      qs -= y
  if K >= 0:
    ans.max= s - qs
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var t = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    y[i] = nextInt()
  solve(N, K, t, y)
else:
  discard

