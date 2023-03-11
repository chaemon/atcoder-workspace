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
var M:int
var l:seq[int]
var r:seq[int]
var s:seq[int]

proc solve() =
  v := newSeq[(int,int)]()
  vs := newSeq[int]()
  w := newSeq[(int,int)]()
  ws := newSeq[int]()
  for i in 0..<N: v.add((l[i], s[i]))
  for i in 0..<N: w.add((r[i], s[i]))
  v.sort()
  w.sort()
  vs.add(0)
  for i in 0..<N: vs.add(vs[^1] + v[i][1])
  ws.add(0)
  for i in 0..<N: ws.add(ws[^1] + w[i][1])
  ans := 0
  for m in 0..<M:
    i := w.lowerBound((m, -int.inf))
    j := v.lowerBound((m+1, -int.inf))
    ans.max= ws[i] + vs[^1] - vs[j]
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  l = newSeqWith(N, 0)
  r = newSeqWith(N, 0)
  s = newSeqWith(N, 0)
  for i in 0..<N:
    l[i] = nextInt() - 1
    r[i] = nextInt() - 1
    s[i] = nextInt()
  solve()
#}}}
