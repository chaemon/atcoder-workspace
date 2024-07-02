when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import std/heapqueue

# Failed to predict input format
solveProc solve():
  let
    N = nextInt()
    A = Seq[N: nextInt()]
  var N2 = 1
  while N2 < N: N2 *= 2
  let Q = nextInt()
  var
    hs = newSeqWith(N2 * 2, initHeapQueue[tuple[x, i:int]]())
    erased = Seq[Q: false]
  proc add(a, b, qid, x:int,t = 1, l = 0, r = N2) =
    if b <= l or r <= a: return
    # l ..< rがa ..< bに含まれる場合
    if a <= l and r <= b:
      hs[t].push((-x, qid))
      return
    if r - l == 1: return
    # 伝搬
    let m = (l + r) shr 1
    # l ..< rとa ..< bの間
    add(a, b, qid, x, t * 2    , l, m)
    add(a, b, qid, x, t * 2 + 1, m, r)
  proc get(i:int, t = 1, l = 0, r = N2):int =
    result = -int.inf
    while true:
      if hs[t].len == 0:
        break
      var (x, qid) = hs[t][0]
      x *= -1
      if qid == -1 or not erased[qid]:
        result.max=x
        break
      discard hs[t].pop()
    if r - l == 1: return
    let m = (l + r) shr 1
    if i < m:
      result.max=get(i, t * 2, l, m)
    elif i < r:
      result.max=get(i, t * 2 + 1, m, r)
    else:
      doAssert false
  for i in N:
    add(i, i + 1, -1, A[i])
  for qid in Q:
    let t = nextInt()
    if t == 1:
      var l, r, x = nextInt()
      l.dec
      add(l, r, qid, x)
    elif t == 2:
      var qid2 = nextInt()
      qid2.dec
      erased[qid2] = true
    elif t == 3:
      var i = nextInt()
      i.dec
      echo get(i)
    else:
      doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

