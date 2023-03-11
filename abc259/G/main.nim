const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/maxflow


solveProc solve(H:int, W:int, A:seq[seq[int]]):
  var
    mf = initMaxFlow[int](H + W + 2)
    s = H + W
    t = s + 1
    score = 0
    As = 0
    lsum = Seq[H: 0]
    rsum = Seq[W: 0]
  # 左にH個、右にW個の頂点
  # S, T陣営に分けてmin-cut(両者が選ばない辺を最小化)
  # 左: S -> 選ばない, T -> 選ぶ
  # 右: S -> 選ぶ, T -> 選ばない
  for i in H:
    for j in W:
      As += A[i][j]
      if A[i][j] >= 0:
        mf.addEdge(i, j + H, A[i][j])
      else:
        score += A[i][j]
        mf.addEdge(j + H, i, int.inf)
        lsum[i] -= A[i][j]
        rsum[j] -= A[i][j]
  for i in H:
    mf.addEdge(s, i, lsum[i])
  for j in W:
    mf.addEdge(j + H, t, rsum[j])
  echo As - (score + mf.flow(s, t))
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
else:
  discard

