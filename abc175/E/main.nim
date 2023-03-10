# header {{{
{.hints:off warnings:off optimization:speed.}
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
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

var R:int
var C:int
var K:int
var r:seq[int]
var c:seq[int]
var v:seq[int]

# input part {{{
proc main()
block:
  R = nextInt()
  C = nextInt()
  K = nextInt()
  r = newSeqWith(K, 0)
  c = newSeqWith(K, 0)
  v = newSeqWith(K, 0)
  for i in 0..<K:
    r[i] = nextInt() - 1
    c[i] = nextInt() - 1
    v[i] = nextInt()
#}}}

var dp = Array(3003, 3003, 4, -int.inf)

import strformat, heapqueue
proc main() =
  var item = initTable[(int,int), int]()
  for i in 0..<K:
    item[(r[i], c[i])] = v[i]
  dp[0][0][0] = 0
  for x in 0..<R:
    for y in 0..<C:
      for n in 0..3:
        if dp[x][y][n] == -int.inf: continue
        if n < 3 and (x,y) in item:
          let v = item[(x, y)]
          if x + 1 < R:
            dp[x + 1][y][0].max=dp[x][y][n] + v
          if y + 1 < C:
            dp[x][y + 1][n + 1].max=dp[x][y][n] + v
        if x + 1 < R:
          dp[x + 1][y][0].max=dp[x][y][n]
        if y + 1 < C:
          dp[x][y + 1][n].max=dp[x][y][n]
  var ans = -int.inf
  for n in 0..3:
    if n < 3 and (R - 1, C - 1) in item:
      ans.max=dp[R - 1][C - 1][n] + item[(R - 1, C - 1)]
    else:
      ans.max=dp[R - 1][C - 1][n]
  print ans
  return

main()

