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

var X:int
var Y:int
var A:int
var B:int
var C:int
var p:seq[int]
var q:seq[int]
var r:seq[int]

#{{{ input part
proc main()
block:
  X = nextInt()
  Y = nextInt()
  A = nextInt()
  B = nextInt()
  C = nextInt()
  p = newSeqWith(A, nextInt())
  q = newSeqWith(B, nextInt())
  r = newSeqWith(C, nextInt())
#}}}

import future

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}
#{{{ findFirst(f, l, r), findLast(f, l, r)
proc findFirst(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, l, r: float, eps: float):float =
  var (l, r) = (l, r)
  if not f(l): return -float(Inf)
  while r - l > eps:
    let m = (l + r) / 2.0
    if f(m): l = m
    else: r = m
  return l
#}}}

proc f(P:int):bool =
  rct := 0
  gct := 0
  ct := 0
  for p in p:
    if p >= P: rct.inc
  for q in q:
    if q >= P: gct.inc
  for r in r:
    if r >= P: ct.inc
  rct.min=X
  gct.min=Y
  if rct + gct + ct >= X + Y: return true
  else: return false

proc count(P:int):int =
  rct := 0
  gct := 0
  ct := 0
  result = 0
  for p in p:
    if p >= P and rct < X: result += p;rct.inc
  for q in q:
    if q >= P and gct < Y: result += q;gct.inc
  let t = X + Y - rct - gct
  result += r[0..<t].sum

proc main() =
  p.sort()
  p.reverse()
  q.sort()
  q.reverse()
  r.sort()
  r.reverse()
  P := f.findLast(0..10^10)
  print P.count()
  return

main()
