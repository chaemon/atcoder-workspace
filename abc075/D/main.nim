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
var K:int
var x:seq[int]
var y:seq[int]

proc solve() =
  xs := newSeq[int]()
  ys := newSeq[int]()
  for i in 0..<N:xs.add(x[i])
  for i in 0..<N:ys.add(y[i])
  xs.sort()
  ys.sort()
  xs = xs.deduplicate()
  ys = ys.deduplicate()
  var ans = int.inf
  for i in 0..<xs.len:
    for i2 in i+1..<xs.len:
      for j in 0..<ys.len:
        for j2 in j+1..<ys.len:
          ct := 0
          for k in 0..<N:
            if xs[i] <= x[k] and x[k] <= xs[i2] and ys[j] <= y[k] and y[k] <= ys[j2]: ct += 1
          if ct >= K:
            ans.min=(xs[i2] - xs[i]) * (ys[j2] - ys[j])
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  K = nextInt()
  x = newSeqWith(N, 0)
  y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve()
#}}}
