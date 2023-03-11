#{{{ header
{.hints:off checks:off.}
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
    var c = getchar()
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

proc solve(N:int, M:int, V:int, P:int, A:seq[int]) =
  var A = A
  A.sort()
  A.reverse
  proc calc(i:int):bool =
    if i <= P - 1: return true
    var B = newSeq[int]()
    t := A[i] + M
    V := V - P
    s := 0
    B = newSeq[int]()
    for j in P - 1..<N:
      if i == j: continue
      B.add(A[j])
    for j in 0..<B.len:
      d := t - B[j]
      if d < 0: return false
      if B.len - j <= V:
        d.min=M
      s += d
    return s >= V * M
  echo findLast(calc,0,N) + 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var V = 0
  V = nextInt()
  var P = 0
  P = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  solve(N, M, V, P, A);
  return

main()
#}}}
