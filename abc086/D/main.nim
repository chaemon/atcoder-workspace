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

var
  N:int
  K:int
  x:seq[int]
  y:seq[int]
  c:seq[string]

import sequtils

# DualCumulativeSum2D(imos) {{{
type DualCumulativeSum2D[T] = object
  H, W:int
  built: bool
  data: seq[seq[T]]

proc initDualCumulativeSum2D[T](W, H:int):DualCumulativeSum2D[T] = DualCumulativeSum2D[T](H:H, W:W, data: newSeqWith(W + 1, newSeqWith(H + 1, T(0))), built:false)
#proc initDualCumulativeSum2D[T](data:seq[seq[T]]):CumulativeSum2D[T] =
#  result = initCumulativeSum2D[T](data.len, data[0].len)
#  for i in 0..<data.len:
#    for j in 0..<data[i].len:
#      result.add(i,j,data[i][j])
#  result.build()

proc add[T](self:var DualCumulativeSum2D[T]; rx, ry:Slice[int], z:T) =
  assert(not self.built)
  let (gx, gy) = (rx.b + 1, ry.b + 1)
  let (sx, sy) = (rx.a, ry.a)
  self.data[gx][gy] += z
  self.data[sx][gy] -= z
  self.data[gx][sy] -= z
  self.data[sx][sy] += z

proc build[T](self:var DualCumulativeSum2D[T]) =
  self.built = true
  for i in 1..<self.data.len:
    for j in 0..<self.data[0].len:
      self.data[i][j] += self.data[i - 1][j]
  for j in 1..<self.data[0].len:
    for i in 0..<self.data.len:
      self.data[i][j] += self.data[i][j - 1]

proc `[]`[T](self: DualCumulativeSum2D[T], x, y:int):T =
  assert(self.built)
#  let (x, y) = (x + 1, y + 1)
  if x >= self.data.len or y >= self.data[0].len: return T(0)
  return self.data[x][y]

proc write[T](self: DualCumulativeSum2D[T]) =
  assert(self.built)
  for i in 0..<self.H:
    for j in 0..<self.W:
      stdout.write(self[i,j])
    echo ""
#}}}

proc solve() =
  cs := initDualCumulativeSum2D[int](2 * K + 1, 2 * K + 1)
  for i in 0..<N:
    x := x[i] mod (2 * K)
    y := y[i] mod (2 * K)
    while x > 0: x -= 2 * K
    while y > 0: y -= 2 * K
    if c[i] == "W": x -= K
    s := 0
    while true:
      base_x := x + s * K
      if base_x >= 2 * K: break
      t := 0
      while true:
        base_y := y + t * K
        if base_y >= 2 * K: break
        if (s + t) mod 2 == 0:
          rx := intersection(0..<2*K, base_x..<base_x+K)
          ry := intersection(0..<2*K, base_y..<base_y+K)
          if rx.len > 0 and ry.len > 0:
            cs.add(rx, ry, 1)
        t.inc
      s.inc
  cs.build()
  var ans = 0
  for i in 0..<2*K:
    for j in 0..<2*K:
      ans.max=(cs[i,j])
  echo ans
  return

#{{{ main function
proc main() =
  N = nextInt()
  K = nextInt()
  x = newSeqWith(N, 0)
  y = newSeqWith(N, 0)
  c = newSeqWith(N, "")
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    c[i] = nextString()
  solve()
  return

main()
