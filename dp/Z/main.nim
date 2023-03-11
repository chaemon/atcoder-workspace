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
var C:int
var h:seq[int]

#{{{ input part
block:
  N = nextInt()
  C = nextInt()
  h = newSeqWith(N, nextInt())
#}}}

# LiChaoTree {{{
type
  Line[T] = object
    a, b:T
  LiChaoTree[T] = object
    sz: int
    xs: seq[T]
    seg: seq[Line[T]]

proc initLine[T](a, b:T):Line[T] = Line[T](a:a, b:b)
proc get[T](self: Line[T], x:T):T = self.a * x + self.b
proc over[T](self, b: Line[T], x: T):bool = self.get(x) < b.get(x)

proc initLiChaoTree[T](x: seq[T], INF):LiChaoTree[T] =
  var xs = x
  var sz = 1
  while sz < xs.len: sz = sz shl 1
  while xs.len < sz: xs.add(xs[^1] + 1)
  return LiChaoTree[T](sz:sz, xs:xs, seg:newSeqWith(2 * sz - 1, initLine(0, INF)))

proc update[T](self: var LiChaoTree[T], x:Line[T], k, l, r:int) =
  let
    mid = (l + r) shr 1
    latte = x.over(self.seg[k], self.xs[l])
    malta = x.over(self.seg[k], self.xs[mid])
  var x = x
  if malta: swap(self.seg[k], x)
  if l + 1 >= r: return
  elif latte != malta: self.update(x, 2 * k + 1, l, mid)
  else: self.update(x, 2 * k + 2, mid, r)

proc update[T](self: var LiChaoTree[T], a, b:T) =
  let l = initLine(a, b)
  self.update(l, 0, 0, self.sz)

proc query[T](self: var LiChaoTree[T], k:int):T =
  let x = self.xs[k]
  var k = k + self.sz - 1;
  result = self.seg[k].get(x)
  while k > 0:
    k = (k - 1) shr 1
    result = min(result, self.seg[k].get(x))
# }}}

block main:
  var lct = initLiChaoTree(h, int.inf)
  lct.update(-2*h[0], h[0]^2 + C)
  for x in 1..<N:
#    let d = cht.query_monotone_inc(h[x]) + h[x] ^ 2
    let d = lct.query(x) + h[x] ^ 2
    lct.update(-2*h[x],  d + h[x] ^ 2 + C)
    if x == N - 1: echo d


