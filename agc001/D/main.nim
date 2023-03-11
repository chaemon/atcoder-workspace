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

const NO = "Impossible"
var N:int
var M:int
var A:seq[int]

#{{{ input part
proc solve():void
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(M, nextInt())
  solve()
#}}}

proc solve() =
  if M == 1:
    if N == 1:
      echo 1
      echo 1
      echo 1
    else:
      echo N
      echo 2
      echo N - 1, " ", 1
    return
  var odd, even = newSeq[int]()
  for a in A:
    if a mod 2 == 0: even.add a
    else: odd.add a
  if odd.len >= 3: echo NO;return
  var
    a = newSeq[int]()
    b = newSeq[int]()
  if odd.len >= 1: a.add(odd[0])
  a &= even
  if odd.len == 2: a.add(odd[1])
  b.add(a[0] + 1)
  for i in 1..<a.len-1: b.add(a[i])
  if a[^1] > 1: b.add(a[^1] - 1)
  echo a.join(" ")
  echo b.len
  echo b.join(" ")
  assert(b.sum == N)
  return
