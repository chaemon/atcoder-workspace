#{{{ header
{.hints:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}

let MOD = 1000000007

#{{{ Mint
type Mint = object
  v:int
proc initMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
proc init[T](self:Mint, a:T):Mint = initMint(a)
proc initMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.v += initMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= initMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= initMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
proc pow(x:Mint, n:int):Mint =
  var (x,n) = (x,n)
  result = initMint(1)
  while n > 0:
    if (n and 1) > 0: result *= x
    x *= x
    n = (n shr 1)
proc extGcd(a,b:int, x,y:var int):int =
  var g = a
  x = 1
  y = 0
  if b != 0:
    g = extGcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g;
proc invMod(a,m:int):int =
  var
    x,y:int
  if extGcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
proc `/=`[T](a:var Mint,b:T):void =
  a.v *= invMod(initMint(b).v,MOD)
  a.v = a.v mod MOD
proc `/`[T](a:Mint,b:T):Mint =
  var c = a
  c /= b
  return c
#}}}

proc solve(D:int, X:int) =
  var
    a = initMint(0) # both side same
    b = initMint(1) # both side different
  proc forward() =
    let
      na = b * (X - 1)
      nb = a + b * (X - 2)
    a = na
    b = nb
  let x = initMint(x)
  var
    same = x * (x - 1) * (x - 1) + x * (x - 1) * (x - 2) * (x - 2)
    diff = initMint(0)
  forward()
  for i in 2..<D:
    var nsame = initMint(0)
    nsame += same * ((x - 1) * (x - 2) + (x - 1)) * a
    nsame += diff * ((x - 1) * (x - 2) + 
    var ndiff = diff * ()
    forward();forward()
    same = nsame
    diff = ndiff
  return

#{{{ main function
proc main() =
  var D = 0
  D = nextInt()
  var X = 0
  X = nextInt()
  solve(D, X);
  return

main()
#}}}
