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
var a:seq[int]
var b:seq[int]
var c:seq[int]

proc warshall_floyd(dist: seq[seq[int]]): seq[seq[int]] =
  let N = dist.len
  var dist = dist
  for k in 0..<N:
    for i in 0..<N:
      for j in 0..<N:
        if dist[i][k] == int.inf or dist[k][j] == int.inf: continue
        let d = dist[i][k] + dist[k][j]
        if dist[i][j] > d: dist[i][j] = d
  return dist

proc solve() =
  dist := newSeqWith(N, newSeqWith(N, int.inf))
  for u in 0..<N: dist[u][u] = 0
  for i in 0..<M:
    dist[a[i]][b[i]] = c[i]
    dist[b[i]][a[i]] = c[i]
  dist = warshallFloyd(dist)
  ans := 0
  for i in 0..<M:
    valid := true
    for u in 0..<N:
      if dist[u][a[i]] + c[i] == dist[u][b[i]]: valid = false
      if dist[u][b[i]] + c[i] == dist[u][a[i]]: valid = false
    if valid: ans += 1
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(M, 0)
  b = newSeqWith(M, 0)
  c = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    c[i] = nextInt()
  solve()
#}}}
