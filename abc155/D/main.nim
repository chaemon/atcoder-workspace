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

proc upperBound*[T](a: openArray[T], key: T): int =
  result = a.low
  var count = a.high - a.low + 1
  var step, pos: int
  while count != 0:
    step = count shr 1
    pos = result + step
    if a[pos] <= key:
      result = pos + 1
      count -= step + 1
    else:
      count = step

#{{{ floorDiv and CeilDiv
proc ceilDiv(a,b:int):int =
  assert(b > 0)
  result = a div b
  let r = a mod b
  if r != 0 and a > 0: result += 1
  assert(b * (result - 1) < a and a <= b * result)
proc floorDiv(a,b:int):int =
  assert(b > 0)
  result = a div b
  let r = a mod b
  if r != 0 and a < 0: result -= 1
  assert(result * b <= a and a < (result + 1) * b)
#}}}

import future

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}

let N, K = nextInt()
var A = newSeqWith(N, nextInt())

A.sort()

proc calcLower(x:int):int =
  return A.upperBound(x)

proc calcUpper(x:int):int =
  return A.len - A.lowerBound(x)

#dump(A)

proc calc(x:int):bool =
  # number x or less
  n := 0
  for i in 0..<N:
#    dump(i)
    if A[i] > 0:
      t := floorDiv(x, A[i])
#      echo " <= ", t
      d := calcLower(t)
#      dump(d)
      n += d
    elif A[i] < 0:
      t := ceilDiv(-x, -A[i])
#      echo " >= ", t
      d := calcUpper(t)
#      dump(d)
      n += d
    else:
      if x >= 0: n += N
  for i in 0..<N:
    if A[i] * A[i] <= x: n -= 1
  n = n div 2
#  echo x, " ", n
  return n >= K

M := N * (N - 1) div 2

#echo calc(-10)

#for i in -10..10:
#  echo calc(i)
echo findFirst(calc, -2*10^18..2*10^18)
