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

var N:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(3*N, nextInt()-1)
#}}}

#const B = 10
const B = 2004
var dp = Array(B, B, -int.inf)

proc get(a, b:int):var int =
  var (a, b) = (a, b)
  if a > b: swap(a, b)
  return dp[a][b]

proc main() =
  var
    max = Array(B, -int.inf)
    max_all = -int.inf
    carry = 0
  get(A[0], A[1]) = 0
  max_all.max=0
  max[A[0]].max=0
  max[A[1]].max=0
  echo max(12, 13)
  for i in 0..<N-1:
    # i * 3 + 2
    var a = [A[i * 3 + 2], A[i * 3 + 3], A[i * 3 + 4]]
    if a[0] == a[1] and a[1] == a[2]: carry.inc;continue
    var update = newSeq[(int,int,int)]()
    for i in 0..<3:
      let j = (i + 1) mod 3
      let k = (i + 2) mod 3
      if a[i] == a[j]:
        let t = a[i]
        for p in 0..<N:
          update.add((a[k], p, get(p, t) + 1))
      update.add((a[i], a[j], get(a[k], a[k]) + 1))
      update.add((a[i], a[j], max_all))
      for p in 0..<N:
        update.add((p, a[i], max[p]))
    for (x,y,t) in update:
      if t >= 0:
        get(x,y).max=t
        max_all.max=t
        max[x].max=t
        max[y].max=t
  var ans = 0
  let t = A[^1]
  ans.max=get(t, t) + 1
  ans.max=max_all
  print ans + carry
  return

main()

