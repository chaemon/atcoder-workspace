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

var N:int
var X:seq[int]
var Y:seq[int]
var U:seq[string]

# input part {{{
proc main()
block:
  N = nextInt()
  X = newSeqWith(N, 0)
  Y = newSeqWith(N, 0)
  U = newSeqWith(N, "")
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
    U[i] = nextString()
#}}}

# default-table {{{
import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, B.default)
  tables.`[]`(self, key)
#}}}

var ans = int.inf

proc main() =
  # UD
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'U':
        tb[X[i]].add(Y[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'D':
        if X[i] notin tb: continue
        let
          v = tb[X[i]]
          j = v.lowerBound(Y[i])
        if j != 0:
          ans.min=(Y[i] - v[j - 1]) * 5
  # LR
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'R':
        tb[Y[i]].add(X[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'L':
        if Y[i] notin tb: continue
        let
          v = tb[Y[i]]
          j = v.lowerBound(X[i])
        if j != 0:
          ans.min=(X[i] - v[j - 1]) * 5
  # RU
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'R':
        tb[X[i] + Y[i]].add(X[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'U':
        let s = X[i] + Y[i]
        if s notin tb: continue
        let
          v = tb[s]
          j = v.lowerBound(X[i])
        if j != 0:
          ans.min=(X[i] - v[j - 1])*10
  # RD
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'R':
        tb[X[i] - Y[i]].add(X[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'D':
        let s = X[i] - Y[i]
        if s notin tb: continue
        let
          v = tb[s]
          j = v.lowerBound(X[i])
        if j != 0:
          ans.min=(X[i] - v[j - 1])*10
  # DL
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'D':
        tb[X[i] + Y[i]].add(X[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'L':
        let s = X[i] + Y[i]
        if s notin tb: continue
        let
          v = tb[s]
          j = v.lowerBound(X[i])
        if j != 0:
          ans.min=(X[i] - v[j - 1])*10

  # UL
  block:
    var tb = initTable[int,seq[int]]()
    for i in 0..<N:
      if U[i][0] == 'U':
        tb[X[i] - Y[i]].add(X[i])
    for k,v in tb.mpairs:
      v.sort()
    for i in 0..<N:
      if U[i][0] == 'L':
        let s = X[i] - Y[i]
        if s notin tb: continue
        let
          v = tb[s]
          j = v.lowerBound(X[i])
        if j != 0:
          ans.min=(X[i] - v[j - 1])*10
  if ans == int.inf:
    print "SAFE"
  else:
    print ans
  return

main()

