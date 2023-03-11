const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import std/heapqueue

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var
    v = Seq[tuple[B, A: int]] # 留年しない人をB順でsort
    qA, qB = initHeapQueue[int]()
    ans = 0
    q = initHeapQueue[(int, int)]() # vの元を(-A, B)の形で保持(Aの大きい順に取り出される)
  for i in N:
    if A[i] < B[i]:
      qA.push A[i]
      qB.push B[i]
      ans.inc
    else:
      v.add (B[i], A[i])
  v.sort
  var i = 0
  while qA.len > 0:
    doAssert qB.len > 0
    let
      A = qA.pop()
      B = qB.pop()
    # vの元(Bi, Ai)のうちBiがA以下のものをqに入れる
    while i < v.len and v[i].B <= A:
      q.push (-v[i].A, v[i].B)
      i.inc
    if A >= B:
      continue
    if q.len == 0: echo -1;return
    var (Ai, Bi) = q.pop()
    Ai *= -1
    ans.inc
    # 今Ai点, 合格Bi点以上の人を追加
    # Aの得点をBiにする
    # 今Ai点, 合格点B点の人が増える
    qA.push(Ai)
    qB.push(B)
  echo N - ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  let N = 10
  discard

