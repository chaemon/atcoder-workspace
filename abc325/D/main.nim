when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import heapqueue

solveProc solve(N:int, T:seq[int], D:seq[int]):
  var
    v:seq[tuple[l, i:int]]
    q = initHeapQueue[tuple[r, i:int]]() # 終了順に
    t = 0
    j = 0
    ans = 0
  for i in N:
    v.add (D[i], i)
  v.sort
  while true:
    if q.len == 0:
      if j == N:
        break
      t.max=v[j].l
      while j < N and v[j].l <= t:
        let (l, i) = v[j]
        q.push((r: D[i] + T[i], i:i))
        j.inc

    let (r, i) = q.pop()
    if r < t:
      continue
    # t <= r
    ans.inc
    t.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    D[i] = nextInt()
  solve(N, T, D)
else:
  discard

