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

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  built:bool
  data: seq[T]

proc initCumulativeSum[T](sz:int = 100):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(sz + 1, T(0)), built:false)
proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = CumulativeSum[T](data: data, built:false)
  result.build()
proc add[T](self: var CumulativeSum[T], k:int, x:T) =
  if self.data.len < k + 2:
    self.data.setlen(k + 2)
  self.data[k + 1] += x

proc build[T](self: var CumulativeSum[T]) =
  self.built = true
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc sum[T](self: CumulativeSum[T], k:int):T =
  assert(self.built)
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  assert(self.built)
  if s.a > s.b: return T(0)
  return self.sum(s.b + 1) - self.sum(s.a)
#}}}

# Failed to predict input format
proc main()
main()

proc main() =
  var H, W = nextInt()
  var s = newSeqWith(H, nextString())
  var ans0 = 0
  var ans = 0
  for ct in 0..<2:
    var a = newSeqWith(H + W - 1, newSeq[(int,int)]())
    var csa = newSeqWith(H + W - 1, initCumulativeSum[int](0))
    for i in 0..<H:
      for j in 0..<W:
        if s[i][j] == '#':
          a[i + j].add((i, j))
          csa[i + j].add(i, 1)
    for i in 0..<csa.len:
      csa[i].build()
    for l in 0..<a.len:
      for i in 0..<a[l].len:
        let (xi, yi) = a[l][i]
        for j in i+1..<a[l].len:
          let
            (xj, yj) = a[l][j]
            d = abs(xi - xj)
          assert(xi <= xj)
          block:
            let
              (xi2, yi2) = (xi, yi - d * 2)
              (xj2, yj2) = (xj - d * 2, yj)
              k = xi2 + yi2
            assert(xj2 <= xi2)
            if 0 <= k and k < csa.len:
              ans0 += csa[k][xi2..xi2]
              ans0 += csa[k][xj2..xj2]
              ans += csa[k][xj2+1..xi2-1]
          block:
            let
              (xi2, yi2) = (xi + d * 2, yi)
              (xj2, yj2) = (xj, yj + d * 2)
              k = xi2 + yi2
            assert(xj2 <= xi2)
            if 0 <= k and k < csa.len:
              ans0 += csa[k][xi2..xi2]
              ans0 += csa[k][xj2..xj2]
              ans += csa[k][xj2+1..xi2-1]
    var s2 = newSeqWith(W, '.'.repeat(H))
    for i in 0..<H:
      for j in 0..<W:
        s2[j][i] = s[i][W - 1 - j]
    swap(H, W)
    swap(s, s2)
  echo ans0 div 2 + ans
  return
