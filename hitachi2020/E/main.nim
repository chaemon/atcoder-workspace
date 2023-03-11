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
#}}}

# newSeqWith {{{
from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var M:int

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
#}}}


proc propagate(a:var seq[seq[int]]) =
  doassert(a.len == a[0].len)
  b := newSeqWith(a.len * 2, a.len * 2, 0)
  for i in 0..<a.len:
    for j in 0..<a.len:
      b[i][j] = a[i][j]
      b[i + a.len][j] = a[i][j]
      b[i][j + a.len] = a[i][j]
      b[i + a.len][j + a.len] = 1 - a[i][j]
  swap(a, b)

proc copy(a: var seq[seq[int]], D:int) =
  doassert(a.len == a[0].len)
  b := newSeqWith(a.len, a.len * D, 0)
  for i in 0..<a.len:
    for j in 0..<a.len:
      for k in 0..<D:
        b[i][j + a.len * k] = a[i][j]
  swap(a, b)

proc main() =
  swapped := false
  if N > M: swap(N, M);swapped = true
  # N <= M
  a := newSeqWith(1, 1, 0)
  for i in 0..<N:
    a.propagate()
  let D = 2^(M - N)
  a.copy(D)
  if swapped:
    var b = newSeqWith(a[0].len, a.len, 0)
    for i in 0..<a.len:
      for j in 0..<a[0].len:
        b[j][i] = a[i][j]
    swap(a, b)
    swap(N, M)
  ans := newSeqWith(2^N - 1, 2^M - 1, 0)
  for i in 1..<2^N:
    for j in 1..<2^M:
      ans[i - 1][j - 1] = (a[i][j] + a[i - 1][j] + a[i][j-1] + a[i-1][j-1]) mod 2
  for i in 0..<ans.len:
    print ans[i].mapIt($it).join("")
  return

main()
