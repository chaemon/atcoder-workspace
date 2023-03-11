const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string, K:int):
  proc normalize(x, y, dx, dy:int):((int, int), int) =
    var
      (x, y) = (x, y)
      k:int
    if dx != 0:
      let
        d = abs(dx)
        r = x.floorMod d
      k = (x - r) div dx
    else:
      let
        d = abs(dy)
        r = y.floorMod d
      k = (y - r) div dy
    x -= k * dx
    y -= k * dy
    return ((x, y), k)
  var
    (x, y) = (0, 0)
    appeared = initSet[(int, int)]()
  for d in S:
    appeared.incl((x, y))
    if d == 'L':
      x.dec
    elif d == 'R':
      x.inc
    elif d == 'U':
      y.dec
    elif d == 'D':
      y.inc
    else:
      doassert false
  if (x, y) == (0, 0):
    echo appeared.len;return
  let (dx, dy) = (x, y)
  var
    a = initTable[(int, int), seq[int]]()
    ans = 0
  for (x, y) in appeared:
    let
      (p, k) = normalize(x, y, dx, dy)
      (x0, y0) = p
    a[(x0, y0)].add k
  for p,v in a:
    var
      v = v.toSet.toSeq.sorted
      r = -int.∞
    for l in v:
      var r2:int
      if p == (0, 0) and l == 0:
        r2 = l + K + 1
      else:
        r2 = l + K
      if r <= l:
        ans += r2 - l
      else:
        ans += r2 - r
      r = r2
    discard
  echo ans
  Naive:
    var
      (x, y) = (0, 0)
      appeared = initSet[(int, int)]()
    for _ in K:
      for d in S:
        appeared.incl((x, y))
        if d == 'L':
          x.dec
        elif d == 'R':
          x.inc
        elif d == 'U':
          y.dec
        elif d == 'D':
          y.inc
        else:
          doassert false
    appeared.incl((x, y))
    echo appeared.len
  return

when not DO_TEST:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  import random
  let dir = "LRUD"
  let K = 10
  for _ in 10000:
    var S = ""
    for i in 10:
      S.add dir[random.rand(0..<4)]
    test(S, K)
