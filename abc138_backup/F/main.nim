import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

let MOD = 1000000007

#{{{ Mint
type Mint = object
  v:int
proc newMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
proc newMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.v += newMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= newMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= newMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
when declared(GCD_H):
  proc `/=`[T](a:var Mint,b:T):void =
    a.v *= invMod(newMint(b).v,MOD)
    a.v = a.v mod MOD
  proc `/`[T](a:Mint,b:T):Mint =
    var c = a
    c /= b
    return c
#}}}

#{{{ bitutils
proc bit(n,d:int):int =
  if (n and (1 shl d)) == 0: 0 else: 1
#}}}

proc solve(L:int, R:int) =
  let M = 62
  var
    dp = newSeqWith(M,newSeqWith(2,newSeqWith(2,newSeqWith(2,Mint()))))
    vis = newSeqWith(M,newSeqWith(2,newSeqWith(2,newSeqWith(2,false))))
  proc calc(d,i,j,k:int): Mint =
    if d == -1: return newMint(1)
    if vis[d][i][j][k]: return dp[d][i][j][k]
    vis[d][i][j][k] = true
    var ans = newMint(0)
    # x[d] = 0, y[d] = 0
    if j == 0 or L.bit(d) == 0:
      var
        i2 = i
        j2 = j
        k2 = k
      if R.bit(d) == 1: k2 = 0
      ans += calc(d-1,i2,j2,k2)
    # x[d] = 0, y[d] = 1
    if i == 0 and (j == 0 or L.bit(d) == 0) and (k == 0 or R.bit(d) == 1):
      var
        i2 = i
        j2 = j
        k2 = k
      ans += calc(d-1,i2,j2,k2)
#    # x[d] = 1, y[d] = 0 : invalid
#    # x[d] = 1, y[d] = 1, r[d] = 0
    if k == 0 or R.bit(d) == 1:
      var
        i2 = 0
        j2 = j
        k2 = k
      if L.bit(d) == 0: j2 = 0
      ans += calc(d-1,i2,j2,k2)
    dp[d][i][j][k] = ans
    return ans
  echo calc(M-1,1,1,1)
#  var ans = newMint(0)
#  for i in 0..1:
#    for j in 0..1:
#      for k in 0..1:
#        ans += calc(M-1,i,j,k)
#  echo ans
  return

proc main() =
  var L = 0
  L = nextInt()
  var R = 0
  R = nextInt()
  solve(L, R);
  return

main()
