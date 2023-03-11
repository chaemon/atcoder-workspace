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
var K:int
var S:string

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  S = nextString()
#}}}

proc `<`(a, b:char):bool = a.ord < b.ord


proc main() =
  c := S.toSet().mapIt(it).min
  if K >= 15:
    print c.repeat(N)
    return
  S2 := S
  S2.reverse
  var
    U = S & S2
    T = 2^(K - 1)
    i = 0
    max_len = -int.inf
    p = newSeq[(int,int)]()
  while i < U.len:
    if U[i] != c:
      i.inc
      continue
    else:
      var j = i
      while j < U.len and U[i] == U[j]: j.inc
      max_len.max=j - i
      p.add((i, j - i))
      i = j
  let prefix = max_len * T
  if prefix >= N:
    print c.repeat(N)
    return
  ans := "~"
  if K == 1:
    for p in p:
      let (i, d) = p
      if d != max_len: continue
      if i + N > N * 2: continue
      ans.min=U[i..<i+N]
    print ans
    return
  for p in p:
    let (i,d) = p
    if d != max_len: continue
    if i + d - N < 0: continue
    V := U[i+d-N..<i]
    V.reverse
#    if (K - 1) mod 2 == 1: V.reverse
    ans.min= c.repeat(prefix) & V[0..<N-prefix]
  print ans
  return

main()
