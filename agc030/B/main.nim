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

var L:int
var N:int
var X:seq[int]

#{{{ input part
proc main()
block:
  L = nextInt()
  N = nextInt()
  X = newSeqWith(N, nextInt())
#}}}

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  pos:int
  data: seq[T]

proc initCumulativeSum[T]():CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(1, T().init(0)), pos:0)
proc `[]=`[T](self: var CumulativeSum[T], k:int, x:T) =
  if k < self.pos: doAssert(false)
  if self.data.len < k + 2:
    self.data.setlen(k + 2)
  for i in self.pos+1..<k:
    self.data[i + 1] = self.data[i]
  self.data[k + 1] = self.data[k] + x
  self.pos = k

proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = initCumulativeSum[T]()
  for i,d in data: result[i] = d

proc sum[T](self: CumulativeSum[T], k:int):T =
  if k < 0: return T().init(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  if s.a > s.b: return T().init(0)
  return self.sum(s.b + 1) - self.sum(s.a)
#}}}

proc main() =
  ans := -int.inf
  for c in 0..<2:
    var
      l = 0
      r = L - X[0]
      i = 0
    while true:
      ans.max = l + r
      r -= L - X[i]
      if i * 2 + 1 >= N: break
      r += 2 * (L - X[i * 2 + 1])
      l += X[i]
      ans.max = l + r
      l += X[i]
      r -= L - X[i + 1]
      if i * 2 + 2 >= N: break
      r += 2 * (L - X[i * 2 + 2])
      ans.max= l + r
      i.inc
    for i in 0..<N:
      X[i] = L - X[i]
    X.reverse
  print ans
  return

main()
