const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc dist(p, q: (int, int)):int =
  return abs(p[0] - q[0]) + abs(p[1] - q[1])


# Failed to predict input format
solveProc solve(B, K, Sx, Sy, Gx, Gy:int):
  var
    Sx0 = Sx.floorDiv(B) * B
    Sx1 = Sx.ceilDiv(B) * B
    Sy0 = Sy.floorDiv(B) * B
    Sy1 = Sy.ceilDiv(B) * B
    Gx0 = Gx.floorDiv(B) * B
    Gx1 = Gx.ceilDiv(B) * B
    Gy0 = Gy.floorDiv(B) * B
    Gy1 = Gy.ceilDiv(B) * B
    ans = dist((Sx, Sy), (Gx, Gy)) * K
  proc calc(p, q:(int, int)):int =
    doAssert p[0] mod B == 0 or p[1] mod B == 0
    doAssert q[0] mod B == 0 or q[1] mod B == 0
    let
      px = p[0] div B
      py = p[1] div B
      qx = q[0] div B
      qy = q[1] div B
    if p[0] mod B != 0 and q[0] mod B != 0:
      if px != qx or py == qy:
        return dist(p, q)
      else:
        # px == qx, py != qy
        let
          r0 = p[0] mod B
          r1 = q[0] mod B
        return dist(p, q) + 2 * min(min(r0, r1), min(B - r0, B - r1))
    elif p[1] mod B != 0 and q[1] mod B != 0:
      if py != qy or px == qx:
        return dist(p, q)
      else:
        let
          r0 = p[1] mod B
          r1 = q[1] mod B
        return dist(p, q) + 2 * min(min(r0, r1), min(B - r0, B - r1))
    else:
      return dist(p, q)

  for p in [(Sx0, Sy), (Sx1, Sy), (Sx, Sy0), (Sx, Sy1)]:
    let d = K * dist(p, (Sx, Sy))
    for q in [(Gx0, Gy), (Gx1, Gy), (Gx, Gy0), (Gx, Gy1)]:
      let d1 = K * dist(q, (Gx, Gy))
      ans.min= d + d1 + calc(p, q)
  echo ans
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let B, K, Sx, Sy, Gx, Gy = nextInt()
    solve(B, K, Sx, Sy, Gx, Gy)
else:
  discard

