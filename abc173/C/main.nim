# header {{{
{.hints:off warnings:off optimization:speed experimental:"codeReordering".}
import algorithm, sequtils, tables, macros, math, sets, strutils, strformat, sugar
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
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


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

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
  parseStmt(a)

template makeArray(x; init):auto =
  when init is typedesc:
    var v:array[x, init]
  else:
    var v:array[x, init.type]
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(a)
#}}}

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: doAssert(false)
proc writeBits[B:SomeInteger](b:B) =
  var n = sizeof(B) * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B =
  if n == 64:
    return not uint64(0)
  else:
    return (B(1) shl B(n)) - B(1)
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if not s.testBit(i):
        found = true
        s.setBit(i)
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

proc main() =
  let H, W, K = nextInt()
  let c = newSeqWith(H, nextString())
  ans := 0
  for bh in 0..<(1 shl H):
    for bw in 0..<(1 shl W):
      ct := 0
      for i in 0..<H:
        if bh[i] == 1: continue
        for j in 0..<W:
          if bw[j] == 1: continue
          if c[i][j] == '#': ct.inc
      if ct == K: ans.inc
  print ans
  return

main()

