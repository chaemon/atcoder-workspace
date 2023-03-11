when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc manhattan_closest_distance[T](A:seq[tuple[x, y:T]]):seq[T] =
  var ans = Seq[A.len: T.inf]
  proc calc(v:seq[int]) =
    if v.len <= 1: return
    let m = v.len div 2
    var
      L = v[0 ..< m]
      R = v[m .. ^1]
    calc(L)
    calc(R)
    # Lのx座標 <= Rのx座標
    # y座標小さい順にする
    L.sort do (i, j:int)->int:
      cmp(A[i].y, A[j].y)
    R.sort do (i, j:int)->int:
      cmp(A[i].y, A[j].y)
    block:
      # Rの値を更新
      block:
        # Lのy座標 <= Rのy座標
        i := 0
        var min_val = T.inf
        for j in R:
          let (x, y) = A[j]
          # L[i].y <= yとなるiを処理
          while i < L.len and A[L[i]].y <= y:
            min_val.min= - A[L[i]].x - A[L[i]].y
            i.inc
          ans[j].min= x + y + min_val
      block:
        # Lのy座標 >= Rのy座標
        i := L.len - 1
        var min_val = T.inf
        for j in R.reversed:
          let (x, y) = A[j]
          # L[i].y >= yとなるiを処理
          while i >= 0 and A[L[i]].y >= y:
            min_val.min= - A[L[i]].x + A[L[i]].y
            i.dec
          ans[j].min= x - y + min_val
    block:
      # Lの値を更新
      # Lのy座標 >= Rのy座標
      block:
        j := 0
        var min_val = T.inf
        for i in L:
          let (x, y) = A[i]
          # R[j].y <= yとなるjを処理
          while j < R.len and A[R[j]].y <= y:
            min_val.min= A[R[j]].x - A[R[j]].y
            j.inc
          ans[i].min= - x + y + min_val
      block:
      # Lのy座標 <= Rのy座標
        j := R.len - 1
        var min_val = T.inf
        for i in L.reversed:
          let (x, y) = A[i]
          # R[i].y >= yとなるjを処理
          while j >= 0 and A[R[j]].y >= y:
            min_val.min= A[R[j]].x + A[R[j]].y
            j.dec
          ans[i].min= - x - y + min_val
  var v = (0 ..< A.len).toSeq
  v.sort do (i, j:int)->int:
    cmp(A[i].x, A[j].x)
  calc(v)
  return ans

# Failed to predict input format
solveProc solve(N:int, P:seq[int]):
  Pred P
  var A = Seq[(int, int)]
  for i in N:
    A.add((i, P[i]))
  echo manhattan_closest_distance(A).join(" ")
  discard

when not defined(DO_TEST):
  let N = nextInt()
  let P = Seq[N: nextInt()]
  solve(N, P)
else:
  discard

