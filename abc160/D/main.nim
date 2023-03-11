#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

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

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var X:int
var Y:int

#{{{ input part
proc main()
block:
  N = nextInt()
  X = nextInt() - 1
  Y = nextInt() - 1
#}}}

# CumulativeSum (Imos){{{
import sequtils

type DualCumulativeSum[T] = object
  pos: int
  data: seq[T]

proc initDualCumulativeSum[T](sz:int = 100):DualCumulativeSum[T] = DualCumulativeSum[T](data: newSeqWith(sz, T(0)), pos: -1)
proc initDualCumulativeSum[T](a:seq[T]):DualCumulativeSum[T] =
  var data = a
  data.add(T(0))
  for i in 0..<a.len:
    data[i + 1] -= a[i]
  return DualCumulativeSum[T](data: data, pos: -1)
proc add[T](self: var DualCumulativeSum[T], s:Slice[int], x:T) =
  assert(self.pos < s.a)
  if s.a > s.b: return
  if self.data.len <= s.b + 1:
    self.data.setlen(s.b + 1 + 1)
  self.data[s.a] += x
  self.data[s.b + 1] -= x

proc `[]`[T](self: var DualCumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  if self.data.len <= k:
    self.data.setlen(k + 1)
  while self.pos < k:
    self.pos += 1
    if self.pos > 0: self.data[self.pos] += self.data[self.pos - 1]
  return self.data[k]
#}}}

proc main() =
  cs := initDualCumulativeSum[int]()
  let C = abs(Y - X) + 1
  d := (C - 1) div 2
  for i in 1..d:
    cs.add(i..i, C)
  if C mod 2 == 0:
    cs.add(d+1..d+1, C div 2)
#  for k in 1..<N:
#    print cs[k]
  let
    t0 = X
    t1 = N - 1 - Y
  for t in [t0, t1]:
    if t == 0: continue
    for u in 1..t:
      cs.add(1..u-1, 1)
      cs.add(u..u, 1)
      cs.add(u+1..u+d, 2)
      if C mod 2 == 0:
        cs.add(u+d+1..u+d+1, 1)
  if t0 > 0 and t1 > 0:
    for u in 1..t0:
      let b = u + 2
      cs.add(b..b+t1-1, 1)
  for k in 1..<N:
    print cs[k]
  return

main()
