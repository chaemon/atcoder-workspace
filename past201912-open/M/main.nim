#{{{ header
{.hints:off warnings:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
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

#{{{ findFirst, findLast
proc findFirst(f:(int)->bool, l, r:int):int =
  var (l, r) = (l, r)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, l, r:int):int =
  var (l, r) = (l, r)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l

proc findFirst(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  if not f(l): return -float(Inf)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): l = m
    else: r = m
  return l
#}}}

proc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  proc f(k:float):bool =
    v := newSeq[float]()
    for i in 0..<N:
      v.add(B[i].float - k * A[i].float)
    v.sort()
    maxVal := -float.inf
    for i in 0..<M:
      maxVal.max=(D[i].float - k * C[i].float)
    if v[^1] + v[^2] + v[^3] + v[^4] + v[^5] >= 0.0: return true
    if v[^1] + v[^2] + v[^3] + v[^4] + maxVal >= 0.0: return true
    return false
  echo findLast(f, 0.0,110000.0, 0.00000001)
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  var C = newSeqWith(M, 0)
  var D = newSeqWith(M, 0)
  for i in 0..<M:
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, M, A, B, C, D);
  return

main()
#}}}
