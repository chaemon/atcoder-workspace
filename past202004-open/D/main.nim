#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
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

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var S:string

#{{{ input part
proc main()
block:
  S = nextString()
#}}}

proc match(T:string):bool =
  for i in 0..<S.len:
    if i + T.len - 1 >= S.len: continue
    var match = true
    for j in 0..<T.len:
      if not (T[j] == '.' or S[i + j] == T[j]): match = false
    if match: return true
  return false

proc getChar(a:int):char =
  if a < 26: return ('a'.ord + a).chr
  else: return '.'

proc main() =
  var ans = 0
  var s:string
  s = newString(1)
  for i in 0..<27:
    s[0] = getChar(i)
    if match(s): ans.inc
  s = newString(2)
  for i in 0..<27:
    for j in 0..<27:
      s[0] = getChar(i)
      s[1] = getChar(j)
      if match(s): ans.inc
  s = newString(3)
  for i in 0..<27:
    for j in 0..<27:
      for k in 0..<27:
        s[0] = getChar(i)
        s[1] = getChar(j)
        s[2] = getChar(k)
        if match(s): ans.inc
  print ans
  return

main()