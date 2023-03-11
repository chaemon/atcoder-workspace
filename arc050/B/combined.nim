#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
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

import bignum

var R:int
var B:int
var x:int
var y:int

proc solve() =
  var ans = 0
  # all (x, 1) or (1, y)
  ans.max=min(R div x, B)
  ans.max=min(B div y, R)
  var v = y * newInt(R) - B
  var a0 = (v div (x * y - 1)).toInt
  var a1:int
  if v mod (x * y - 1) == 0:
    a1 = a0
  else:
    if v >= 0:
      a1 = a0 + 1
    else:
      a1 = a0 - 1
  for a in [a0, a1]:
    if a < 0: continue
    var b = R - a * x
    if B - a >= 0: b.min= (B - a) div y
    else: b.min= -1
    if b < 0: continue
    ans.max=a + b
  echo ans
  return

#{{{ input part
block:
  R = nextInt()
  B = nextInt()
  x = nextInt()
  y = nextInt()
  solve()
#}}}
