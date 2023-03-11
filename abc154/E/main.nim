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

var N:string
var K:int

proc comb(n,r:int):int = 
  if n < 0 or r < 0 or n < r: return 0
  a := 1
  b := 1
  for i in 0..<r:
    a *= n - i
    b *= i + 1
  return a div b

proc solve() =
  a := newSeq[int]()
  for i in 0..<N.len:
    a.add(N[i].ord - '0'.ord)
  ct := 0
  ans := 0
  for i in 0..<a.len:
    if ct > K:
      break
    if a[i] > 0:
    # set to 0
      ans += comb(a.len - 1 - i, K - ct) * 9^(K - ct)
    # set to non-zero
      if K - ct - 1 >= 0:
        ans += (a[i] - 1) * comb(a.len - 1 - i, K - ct - 1) * 9^(K - ct - 1)
#    echo i, " ", ct, " ", ans
    if a[i] != 0:
      ct += 1
  if ct == K: ans += 1
  echo ans
  return

#{{{ input part
block:
  N = nextString()
  K = nextInt()
  solve()
#}}}
