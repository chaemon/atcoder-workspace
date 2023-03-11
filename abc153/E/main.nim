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

var H:int
var N:int
var A:seq[int]
var B:seq[int]

proc solve() =
  dp := newSeqWith(H+1, -1)
  proc calc(H:int):int =
    if dp[H] >= 0: return dp[H]
    if H == 0:
      dp[H] = 0
      return 0
    var ans = int.inf
    for i in 0..<N:
      let nextH = max(0, H - A[i])
      ans.min= calc(nextH) + B[i]
    dp[H] = ans
    return dp[H]
  echo calc(H)
  return

#{{{ input part
block:
  H = nextInt()
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve()
#}}}
