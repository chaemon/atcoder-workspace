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

#{{{ Slice
proc len[T](self: Slice[T]):int = (if self.a > self.b: 0 else: self.b - self.a + 1)
proc empty[T](self: Slice[T]):bool = self.len == 0

proc `<`[T](p, q: Slice[T]):bool = return if p.a < q.a: true elif p.a > q.a: false else: p.b < q.b
proc intersection[T](p, q: Slice[T]):Slice[T] = max(p.a, q.a)..min(p.b, q.b)
proc union[T](v: seq[Slice[T]]):seq[Slice[T]] =
  var v = v
  v.sort(cmp[Slice[T]])
  result = newSeq[Slice[T]]()
  var cur = -T.inf .. -T.inf
  for p in v:
    if p.empty: continue
    if cur.b + 1 < p.a:
      if cur.b != -T.inf: result.add(cur)
      cur = p
    elif cur.b < p.b: cur.b = p.b
  if cur.b != -T.inf: result.add(cur)
proc `in`[T](s:Slice[T], x:T):bool = s.contains(x)
proc `*`[T](p, q: Slice[T]):Slice[T] = intersection(p,q)
proc `+`[T](p, q: Slice[T]):seq[Slice[T]] = union(@[p,q])
#}}}

const YES = "Yes"
const NO = "No"
var A:int
var B:int
var C:int

proc solve() =
  if A > B: swap(A, B)
  if C in A..B:
    echo YES
  else:
    echo NO
  return

#{{{ input part
block:
  A = nextInt()
  B = nextInt()
  C = nextInt()
  solve()
#}}}
