const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc normalize(a, b, c:var int) =
  if c < 0:
    a *= -1;b *= -1;c *= -1
  if c != 0:
    var g = gcd(gcd(a, c), b)
    doAssert g > 0
    a.div=g;b.div=g;c.div=g
  else:
    if b < 0:
      a *= -1;b *= -1;c *= -1
    if b != 0:
      var g = gcd(a, b)
      doAssert g > 0
      a.div=g;b.div=g
    else:
      a = 1


solveProc solve(N:int, X:seq[int], Y:seq[int], C:seq[int]):
  var t = initTable[tuple[x, y:int], seq[(tuple[a, b, c:int], int)]]()
  for i in N:
    for j in i + 1 ..< N:
      var (mx, my) = (X[i] + X[j], Y[i] + Y[j])
      # (X[i], Y[i])と(X[j], Y[j])の垂直二等分線
      # ax + by + c = 0
      a := (X[j] - X[i]) * 2
      b := (Y[j] - Y[i]) * 2
      c := X[i]^2 - X[j]^2 + Y[i]^2 - Y[j]^2
      normalize(a, b, c)
      t[(mx, my)].add(((a, b, c), C[i] + C[j]))
  dp := initTable[tuple[a, b, c:int], int]()
  ans := -int.inf
  for k, v in t:
    for (p, C) in v:
      if p in dp:
        ans.max= C + dp[p]
    for (p, C) in v:
      if p in dp:
        dp[p].max= C
      else:
        dp[p] = C
  echo if ans == -int.inf: -1 else: ans
  return

when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
    C[i] = nextInt()
  solve(N, X, Y, C)
else:
  discard

