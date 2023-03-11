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

var N:int
var H:seq[int]
var P:seq[int]

#{{{ input part
block:
  N = nextInt()
  H = newSeqWith(N, 0)
  P = newSeqWith(N, 0)
  for i in 0..<N:
    H[i] = nextInt()
    P[i] = nextInt()
#}}}

block main:
  v := newSeq[tuple[H:int,P:int]]()
  for i in 0..<N:
    v.add((H[i], P[i]))
  v.sort() do (a, b:tuple[H:int,P:int])->int:
    cmp(a.H + a.P, b.H + b.P)
  for i in 0..<N:
    H[i] = v[i].H
    P[i] = v[i].P
  dp := newSeqWith(N + 1, int.inf)
  dp[0] = 0
  for i in 0..<N:
    dp2 := dp
    for j in 0..<N:
      if dp[j] == int.inf: continue
      if dp[j] > H[i]: continue
      dp2[j+1].min=dp[j] + P[i]
    swap(dp, dp2)
  for t in countdown(N, 0):
    if dp[t] == int.inf: continue
    echo t;break
  break
