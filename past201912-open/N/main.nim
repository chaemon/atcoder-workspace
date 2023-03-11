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

proc initCumulativeSum[T](sz:int = 100):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(sz, T(0)), built:false)
proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = CumulativeSum[T](data: data, built:false)
  result.build()
proc add[T](self: var CumulativeSum[T], k:int, x:T) =
  if self.data.len < k + 1:
    self.data.setlen(k + 1)
  self.data[k] += x

proc build[T](self: var CumulativeSum[T]) =
  self.built = true
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc `[]`[T](self: CumulativeSum[T], k:int):T =
  assert(self.built)
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  assert(self.built)
  if s.a > s.b: return T(0)
  return self[s.b] - self[s.a - 1]
#}}}

proc solve(N:int, W:int, C:int, l:seq[int], r:seq[int], p:seq[int]) =
  proc normalize(x:int):int =
    if x < 0: return -1
    elif x > W: return W + 1
    else: return x
  cm := initSet[int]()
  cm.incl(-1)
  cm.incl(0)
  for i in 0..<N:
    var x = normalize(l[i] - C)
    var y = normalize(r[i])
    cm.incl(x)
    cm.incl(y)
  cm.incl(W - C)
  cm.incl(W)
  cm.incl(W + 1)
  cm2 := newSeq[int]()
  for cmi in cm:
    cm2.add(cmi)
  cm2.sort()
  tb := initTable[int,int]()
  for i,cmi in cm2:
    tb[cmi] = i
  cs := initCumulativeSum[int](cm.len + 3)
  for i in 0..<N:
    let xi = tb[normalize(l[i] - C)]
    let yi = tb[normalize(r[i])]
    cs.add(xi + 1, p[i])
    cs.add(yi, -p[i])
  cs.build()
  var ans = int.inf
  for i in tb[0]..tb[W-C]:
    ans.min=(cs[0..i])
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var W = 0
  W = nextInt()
  var C = 0
  C = nextInt()
  var l = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  var p = newSeqWith(N, 0)
  for i in 0..<N:
    l[i] = nextInt()
    r[i] = nextInt()
    p[i] = nextInt()
  solve(N, W, C, l, r, p);
  return

main()
#}}}
