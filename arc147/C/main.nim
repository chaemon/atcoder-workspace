const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, L:seq[int], R:seq[int]):
  proc f(M:int):int =
    var x = Seq[N: int]
    for i in N:
      if R[i] < M:
        x[i] = R[i]
      elif M < L[i]:
        x[i] = L[i]
      else: x[i] = M
    x.sort()
    ans := 0
    for i in x.len - 1:
      let d = x[i + 1] - x[i]
      ans += d * (i + 1) * (x.len - i - 1)
    return ans

  var a = Seq[tuple[x, t, i: int]] # t = 0: 入れる, t = 1出す
  for i in N:
    a.add (L[i], 0, i)
    a.add (R[i], 1, i)
  a.sort
  var
    i = 0
    X = a[0].x
    v = f(X)
    ans = v
    lct = 0 # 中心より左にあるものの数
    rct = 0
  for i in N:
    if X <= L[i]:
      rct.inc
  while true:
    #doAssert v == f(X)
    while i < a.len and a[i].x == X:
      if a[i].t == 1:
        lct.inc
      elif a[i].t == 0:
        rct.dec
      i.inc
    if i == a.len: break
    X2 := a[i].x
    # X -> X2
    v += lct * (N - lct) * (X2 - X) - rct * (N - rct) * (X2 - X)
    X = X2
    ans.min = v
    discard
  echo ans






  #var
  #  l = 0
  #  r = 2 * 10^7
  #while r - l >= 3:
  #  let
  #    t = (r - l) div 3
  #    L0 = f(l + t)
  #    R0 = f(r - t)
  #  if L0 <= R0:
  #    r -= t
  #  else:
  #    l += t
  #var ans = int.inf
  #for u in l .. r:
  #  ans.min=f(u)
  #echo ans

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, L, R)
else:
  discard
