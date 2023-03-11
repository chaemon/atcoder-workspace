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
#{{{ findFirst(f, l..r, eps), findLast(f, l..r, eps)
proc findFirst(f:(float)->bool, s: Slice[float], eps: float):float =
  var (l, r) = (s.a, s.b)
  while r - l > eps:
    let m = (l + r) * 0.5
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, s: Slice[float], eps: float):float =
  var (l, r) = (s.a, s.b)
  if not f(l): return -float(Inf)
  while r - l > eps:
    let m = (l + r) * 0.5
    if f(m): l = m
    else: r = m
  return l
#}}}

var N:int
var M:int
var a:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(2*N, nextInt())
#}}}

proc calc(t:int):bool =
  dump(t)
  used := ndSeq(N * 2, false)
  var i = 2 * N - 1
  var j = 0
  while true:
    dump(i)
    dump(a[i])
    dump(j)
    var j0 = -1
    while j < i:
      let s = a[i] + a[j]
      if M <= s and s <= M + t: j0 = j
      if a[i] + a[j] > M + t: break
      j.inc
    dump(j0)
    if j0 == -1:
      break
    echo "found: ", a[i], " ", a[j0]
    used[j0] = true
    used[i] = true
    i.dec
  v := newSeq[int]()
  for i in 0..<N*2:
    if used[i]: continue
    v.add(a[i])
  echo v
  for i in 0..<v.len:
    let j = v.len - 1 - i
    if i > j: break
    if v[i] + v[j] > t: return false
  echo "true!!"
  return true

proc main() =
  a.sort()
  echo calc(0)
#  for i in 0..<M:
#    echo calc(i)
#  echo calc.findFirst(0..M)
  return

main()
