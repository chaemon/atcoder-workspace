#{{{ header
{.hints:off warnings:off.}
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
#}}}

import sequtils

# CumulativeSum2D {{{
type CumulativeSum2D[T] = object
  built: bool
  data: seq[seq[T]]

proc initCumulativeSum2D[T](W, H:int):CumulativeSum2D[T] = CumulativeSum2D[T](data: newSeqWith(W + 1, newSeqWith(H + 1, T(0))), built:false)
proc initCumulativeSum2D[T](data:seq[seq[T]]):CumulativeSum2D[T] =
  result = initCumulativeSum2D[T](data.len, data[0].len)
  for i in 0..<data.len:
    for j in 0..<data[i].len:
      result.add(i,j,data[i][j])
  result.build()

proc add[T](self:var CumulativeSum2D[T]; x, y:int, z:T) =
  let (x, y) = (x + 1, y + 1)
  if x >= self.data.len or y >= self.data[0].len: return
  self.data[x][y] += z

proc build[T](self:var CumulativeSum2D[T]) =
  self.built = true
  for i in 1..<self.data.len:
    for j in 1..<self.data[i].len:
      self.data[i][j] += self.data[i][j - 1] + self.data[i - 1][j] - self.data[i - 1][j - 1]

proc `[]`[T](self: CumulativeSum2D[T], rx, ry:Slice[int]):T =
  assert(self.built)
  let (gx, gy) = (rx.b+1, ry.b+1)
  let (sx, sy) = (rx.a, ry.a)
  return self.data[gx][gy] - self.data[sx][gy] - self.data[gx][sy] + self.data[sx][sy]
#}}}

proc solve(N:int, M:int, Q:int, L:seq[int], R:seq[int], p:seq[int], q:seq[int]) =
  cs := initCumulativeSum2D[int](N+5,N+5)
  for i in 0..<M: cs.add(L[i], R[i], 1)
  cs.build()
  for i in 0..<Q: echo cs[p[i]..q[i], p[i]..q[i]]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var Q = 0
  Q = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
  var p = newSeqWith(Q, 0)
  var q = newSeqWith(Q, 0)
  for i in 0..<Q:
    p[i] = nextInt()
    q[i] = nextInt()
  solve(N, M, Q, L, R, p, q);
  return

main()
#}}}
