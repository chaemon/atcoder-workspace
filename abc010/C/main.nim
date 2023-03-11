#{{{ header
{.hints:off warnings:off optimization:speed.}
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
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

const YES = "YES"
const NO = "NO"
var tx_a:int
var ty_a:int
var tx_b:int
var ty_b:int
var T:int
var V:int
var n:int
var x:seq[int]
var y:seq[int]

proc solve() =
  for i in 0..<n:
    s := sqrt(((tx_a - x[i])^2+(ty_a - y[i])^2).float) + sqrt(((tx_b - x[i])^2+(ty_b - y[i])^2).float)
    if s <= (T*V).float: echo YES;return
  echo NO
  return

#{{{ input part
block:
  tx_a = nextInt()
  ty_a = nextInt()
  tx_b = nextInt()
  ty_b = nextInt()
  T = nextInt()
  V = nextInt()
  n = nextInt()
  x = newSeqWith(n, 0)
  y = newSeqWith(n, 0)
  for i in 0..<n:
    x[i] = nextInt()
    y[i] = nextInt()
  solve()
#}}}
