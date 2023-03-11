const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var C = Seq[2^N, N: nextInt()]
  for i in C.len:
    C[i] = 0 & C[i]
  proc calc(t, i:int):tuple[a:seq[int], m:int] =
    if t == N:
      return (@[0], 0)
    # t段目のi番目の試合の勝敗を考える
    # 対象は2^(N - i)人
    let
      d = 2^(N - t)
      l = d * i
      r = d * (i + 1)
      mid = d div 2
    # l ..< rを考える
    let
      (al, ml) = calc(t + 1, i * 2)
      (ar, mr) = calc(t + 1, i * 2 + 1)
    # N - i回勝つ場合の勝敗を決める
    (a, m) =& result
    a.setLen(2^(N - t))
    for j in l ..< l + mid:
      var d = C[j][N - t]
      if N - t - 1 >= 0:
        d -= C[j][N - t - 1]
      a[j - l] = al[j - l] + mr + d
    for j in l + mid ..< r:
      var d = C[j][N - t]
      if N - t - 1 >= 0:
        d -= C[j][N - t - 1]
      a[j - l] = ar[j - l - mid] + ml + d
    m = a.max
  echo calc(0, 0).m
  discard

when not defined(DO_TEST):
  solve()
else:
  discard
