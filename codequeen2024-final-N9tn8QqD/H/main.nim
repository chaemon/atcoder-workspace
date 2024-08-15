when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import heapqueue

solveProc solve(N:int, K:int, T:int, A:seq[int], B:seq[int]):
  var ans = int.inf
  # 全部ファストパスの場合
  block:
    var B = B
    B.sort(SortOrder.Ascending)
    var
      s = 0
      k = 0
    while true:
      if k == B.len or s + B[k] > T or k + 1 > K: break
      s += B[k]
      k.inc
    ans.min=k
  # ファストパスK枚とそれ以外
  var v:seq[tuple[d, A, B:int]]
  for i in N:
    v.add (A[i] - B[i], A[i], B[i])
  v.sort(SortOrder.Descending)
  var
    a:seq[int] # a[i]は0 ..< iのうちmin(i, K)個のアトラクションをファストパスで乗る場合の所用時間
    q = initHeapQueue[int]() # 逆順
    qs = 0
  # ファストパスはK枚 + その他
  # または全部ファストパス
  # i < Kの時はどうするか？
  for i, (d, A, B) in v:
    a.add qs
    q.push -B
    qs += B
    if q.len > K:
      qs -= -q.pop
      doAssert q.len == K
  a.add qs
  var
    q0, q1 = initHeapQueue[int]() # q0が小さい方, q0: 逆順, q1: 正順
    # q0の合計がT - t[i]以下に抑える
    q0s = 0
  # T - a[i]は単調増加
  for i in 0 ..< N << 1: # 逆順
    let (_, A, B) = v[i]
    # Aとq1の先頭と比較。q1が空ならq0に入れる
    if q1.len == 0 or A <= q1[0]:
      q0.push -A
      q0s += A
    else:
      q1.push A
    # q0sをT - a[i]に引き上げ
    if q0s > T - a[i]:
      # q0 -> q1
      while q0.len > 0 and q0s > T - a[i]:
        let u = -q0.pop
        q0s -= u
        q1.push u
    else:
      while q1.len > 0:
        if q0s + q1[0] > T - a[i]: break
        let u = q1.pop
        q0.push -u
        q0s += u
    if T - a[i] >= 0:
      let p = min(i, K) + q0.len
      ans.max= p
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var T = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, K, T, A, B)
else:
  discard

