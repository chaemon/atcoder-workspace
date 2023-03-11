#{{{ header
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
# }}}

let
  N = 200000
  Q = 200000
  V = 10'u^19

type OP = enum
  PLUS
  LT

type P = tuple[t:OP,i,j,k:int]

var ans = newSeq[P]()

const B = 30

# use 3, 4, ..., 3 + B

ans &= @[(PLUS, 0, 1, 4)]
ans &= @[(LT, 2, 4, 4)]
let ONE_I = 4
let ZERO_I = 3

proc mult2(i, n:int):seq[P] = 
  for j in 0..<n:
    result.add((PLUS, i, i, i))
proc AND(i,j,to:int):seq[P] =
  @[(PLUS, i, j, to), (LT, ONE_I, to, to)]
proc OR(i,j,to:int):seq[P] =
  @[(PLUS, i, j, to), (LT, ZERO_I, to, to)]
proc NOT(i, to:int):seq[P] =
  @[(LT, i, ONE_I, to)]


proc binary(s, d, tmp0, tmp1:int):seq[P] = # use d, d + 1, d + 2, ...
  result = newSeq[P]()
  result.add((PLUS, ZERO_I, ZERO_I, tmp0))
  # tmp0: sum
  # tmp1: 
  for i in countdown(B - 1, 0):
    result.add (PLUS, ZERO_I, ONE_I, tmp1)
    result &= mult2(tmp1, i)
    result.add (PLUS, tmp1, tmp0, tmp1)
    result.add (LT, s, tmp1, d + i)
    result &= NOT(d + i, d + i)
    # now d + i is set
    result.add (PLUS, ZERO_I, d + i, tmp1)
    result &= mult2(tmp1, i)
    result.add (PLUS, tmp1, tmp0, tmp0)

proc test(A, B:int, q:seq[P]):seq[uint] = 
  assert(q.len <= Q)
  var a = newSeq[uint](N)
  a[0] = A.uint
  a[1] = B.uint
  for (t, i, j, k) in q:
    if t == PLUS:
      a[k] = a[i] + a[j]
    else:
      a[k] = if a[i] < a[j]: 1 else: 0
    assert a[k] <= V
  return a

let tmp0 = 10000
let tmp1 = 10001

let base_A = ONE_I + 1
ans &= binary(0, base_A, tmp0, tmp1)
let base_B = base_A + B
ans &= binary(1, base_B, tmp0, tmp1)

for i in 0..<B:
  for j in 0..<B:
    ans &= AND(base_A + i, base_B + j, tmp0)
    ans &= mult2(tmp0, i + j)
    ans.add (PLUS, 2, tmp0, 2)

#dump(ans.len)

#let (X, Y) = (1000000097, 314159265)
#let (X, Y) = (0, 0)
#echo test(X, Y, ans)[0..<110]
#dump(X * Y)
#echo test(29, 37, ans)[0..<200]

proc output(ans:seq[P]) =
  echo ans.len
  for (t, i, j, k) in ans:
    if t == PLUS:
      echo fmt"+ {i} {j} {k}"
    else:
      echo fmt"< {i} {j} {k}"

ans.output()
