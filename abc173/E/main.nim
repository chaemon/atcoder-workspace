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

const MOD = 1000000007
var N:int
var K:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

import atcoder/modint
import atcoder/extra/header/rev_slice

type mint = modint1000000007

proc main() =
  if N == K:
    var p = mint(1)
    for i in 0..<N:p *= A[i]
    echo p;return
  var A = A
  A.sort() do (a, b:int)->int:
    -cmp[int](a.abs, b.abs)
  block:
    var neg_ct = 0
    for i in 0..<N:
      if A[i] < 0: neg_ct.inc
    if neg_ct == N and K mod 2 == 1:
      var p = mint(1)
      for i in 0..<K:
        p *= A[N - 1 - i]
      echo p
      return
  var
    p = mint(1)
    neg_ct = 0
  for i in 0..<K:
    if A[i] < 0: neg_ct.inc
    p *= mint(A[i].abs)
  if neg_ct mod 2 == 0: echo p;return
  var i0, j0, i1, j1 = -1
  # remove neg, add pos
  for i in reversed(0..<K):
    if A[i] < 0:
      i0 = i
      break
  for i in K..<N:
    if A[i] >= 0:
      j0 = i
      break
  for i in reversed(0..<K):
    if A[i] >= 0:
      i1 = i
      break
  for i in K..<N:
    if A[i] < 0:
      j1 = i
      break
  var f0, f1 = true
  if i0 == -1 or j0 == -1: f0 = false
  if i1 == -1 or j1 == -1: f1 = false
  if f0 and not f1:
    echo p / A[i0].abs * A[j0].abs;return
  if f1 and not f0:
    echo p / A[i1].abs * A[j1].abs;return
  if f0 and f1:
    if A[j0].abs * A[i1].abs >= A[j1].abs * A[i0].abs:
      echo p / A[i0].abs * A[j0].abs
    else:
      echo p / A[i1].abs * A[j1].abs
    return
  # not f0 and not f1
  doAssert(false)
  return

main()

