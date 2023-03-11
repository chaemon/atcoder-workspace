const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

proc l[T](r:Slice[T]):T = r.a
proc r[T](r:Slice[T]):T = r.b + 1

proc intersection[T](a, b:Slice[T]):Slice[T] =
  if a.r <= b.l or b.r <= a.l: return 1 ..< 0
  else: return max(a.l, b.l) ..< min(a.r, b.r)

proc len[T](a:Slice[T]):int =
  if a.l >= a.r: return 0
  return a.r - a.l

solveProc solve(N:int, AX:int, BX:int, AY:int, BY:int):
  var (AX, BX, AY, BY) = (AX, BX, AY, BY)
  proc getRange(k:int):auto = 
    let LX = AX + k * BX
    let LY = AY + k * BY
    return intersection(LX..<LX+BX, LY..<LY+BY)
  if BX > BY: swap(AX, AY);swap(BX, BY)
  if BX < BY:
    let AY = AY + (AX - AY) * BY
    # AX + k * BX
    # AY + k * BY
    let k0 = (AX - AY - BY).ceilDiv (BY - BX)
    let k1 = (AX + BX - AY - BY).ceilDiv (BY - BX)
    let k2 = (AX - AY).ceilDiv (BY - BX)
    let k3 = (AX - AY + BX).ceilDiv (BY - BX)

    var kl = max((1 - AY).ceilDiv(BY), 1)
    var kr = (N + 1 - AY).ceilDiv(BY)

    # k0..<k1
    # k1..<k2
    # k2..<k3

  else: # BX == BY
    discard
  discard



let T = nextInt()

for _ in T:
  let N, AX, BX, AY, BY = nextInt()
  solve(N, AX, BX, AY, BY)



