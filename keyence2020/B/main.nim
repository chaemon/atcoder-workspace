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
var X:seq[int]
var L:seq[int]

proc solve() =
  id := newSeq[int]()
  v := newSeq[(int,int)]()
  for i in 0..<N:
    v.add((X[i] - L[i], X[i] + L[i]))
  v.sort()
  id.insert(-int.inf)
  id.insert(int.inf)
  for i in 0..<N:
    id.add(v[i][0])
    id.add(v[i][1])
  id = id.toSet.mapIt(it)
  id.sort()
  dp := newSeqWith(id.len, 0)
  i := 0
  for j in 0..<dp.len:
    if j > 0: dp[j].max = dp[j-1]
    while i < N and v[i][0] == id[j]:
      let tail = id.lowerBound(v[i][1])
      dp[tail] .max= dp[j] + 1
      i += 1
  echo dp[^1]
  return

#{{{ input part
block:
  N = nextInt()
  X = newSeqWith(N, 0)
  L = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    L[i] = nextInt()
  solve()
#}}}
