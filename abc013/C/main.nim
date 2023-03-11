#{{{ header
{.hints:off checks:on.}
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
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

import future

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

proc ceilDiv(a,b:int):int =
  assert(b > 0)
  result = a div b
  let r = a mod b
  if r != 0 and a > 0: result += 1
proc floorDiv(a,b:int):int =
  assert(b > 0)
  result = a div b
  let r = a mod b
  if r != 0 and a < 0: result -= 1

proc solve(N:int, H:int, A:int, B:int, C:int, D:int, E:int) =
#  proc calc(M: int): bool =
#    var
#      M = M
#      H = H
#    for d in 0..N:
#      if M < 0: break
#      let e = M div C
#      if d + e >= N: return true
#      if float(e) * float(D) + float(H) >= float(10^18): return true
#      let H2 = H + e * D
#      let f = N - d - e
#      if H2 > E * f: return true
#      H += B
#      M -= A
#    return false
#  echo findFirst(calc, 0, 10^15 + 1)
  var
    H = H
    M = 0
  var ans = int.inf
  for d in 0..N:
    let R = N - d
    var k = 0
    if R * E - H >= 0:
      k = min(R, ceilDiv(R * E - H + 1, D + E))
    ans .min= (k * C + M)
    H += B
    M += A
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var H = 0
  H = nextInt()
  var A = 0
  A = nextInt()
  var B = 0
  B = nextInt()
  var C = 0
  C = nextInt()
  var D = 0
  D = nextInt()
  var E = 0
  E = nextInt()
  solve(N, H, A, B, C, D, E);
  return

main()
#}}}
