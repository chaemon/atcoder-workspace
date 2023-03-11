#{{{ header
{.hints:off checks:off.}
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

let p = 43
#let p = 2
let N = p^2 + p + 1
let K = p + 1

proc P(a:varargs[int]):int =
  var t = 0
  if a.len == 0: return t + 0 + 1
  t += 1
  if a.len == 1: return t + a[0] + 1
  t += p
  if a.len == 2: return t + a[0] * p + a[1] + 1
  assert(false)

echo N, " ", K
ans := newSeq[seq[int]]()

block:
  var v = newSeq[int]()
  v.add P()
  for i in 0..<p:v.add(P(i))
  ans.add v

block:
  for c in 0..<p:
    var v = newSeq[int]()
    v.add(P())
    for i in 0..<p:
      v.add(P(i, c))
    ans.add(v)

block:
  for r in 0..<p:
    for c in 0..<p:
      var v = newSeq[int]()
      v.add(P(c))
      for i in 0..<p:
        v.add(P((r + c * i) mod p, i))
      ans.add(v)

for a in ans:
  echo a.mapIt($it).join(" ")
