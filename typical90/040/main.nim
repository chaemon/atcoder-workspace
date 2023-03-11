const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import atcoder/maxflow

# ノード数N + 2でN個の家とs, t
# min-cutで求める
# -(料金)の最小化
# S陣営とT陣営がある
# 鍵を開けることはS陣営に入ることとする。

const INF = int(1000000000000)

block main:
  let N, W = nextInt()
  var
    f = initMaxFlow[int](N + 2)
    ans = 0
  let
    s = N
    t = s + 1
    A = Seq[N: nextInt()]
  for u in N:
    # S陣営に入る(=開ける)とコストW - A[u]円
    let m = W - A[u]
    if m >= 0:
      f.addEdge(u, t, m)
    else:
      ans += m
      f.addEdge(s, u, -m)
  for u in N:
    let
      k = nextInt()
      c = Seq[k: nextInt() - 1]
    for i in k:
      # uの中にc[i]の鍵がある
      # c[i]がS陣営 => uもS陣営
      f.addEdge(c[i], u, INF)
  ans += f.flow(s, t)
  ans *= -1
  echo ans



