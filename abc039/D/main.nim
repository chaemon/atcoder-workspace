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

const YES = "possible"
const NO = "impossible"
var H:int
var W:int
var S:seq[string]

proc solve() =
  var S2 = newSeqWith(H, '#'.repeat(W))
  for i in 0..<H:
    for j in 0..<W:
      if S[i][j] == '#': continue
      for s in -1..1:
        i2 := i + s
        if not (0 <= i2 and i2 < H): continue
        for t in -1..1:
          j2 := j + t
          if not (0 <= j2 and j2 < W): continue
          S2[i2][j2] = '.'
  var S3 = newSeqWith(H, '?'.repeat(W))
  for i in 0..<H:
    for j in 0..<W:
      var found = false
      for s in -1..1:
        i2 := i + s
        if not (0 <= i2 and i2 < H): continue
        for t in -1..1:
          j2 := j + t
          if not (0 <= j2 and j2 < W): continue
          if S2[i2][j2] == '#': found = true
      if found: S3[i][j] = '#'
      else: S3[i][j] = '.'
  if S3 == S:
    echo YES
    for s in S2:
      echo s
  else:
    echo NO
  return

#{{{ input part
block:
  H = nextInt()
  W = nextInt()
  S = newSeqWith(H, nextString())
  solve()
#}}}
