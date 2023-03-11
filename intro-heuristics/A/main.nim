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
  for x in lens:
    a = fmt"makeArray({x.repr}, {a})"
  parseStmt(a)
# }}}

import random, times

let t0 = epochTime()

randomize()

let
  B = 26
  D = nextInt()
  c = Seq(B, nextInt())
  s = Seq(D, B, nextInt())

proc eval(ans:seq[int]):int =
  result = 0
  var last = Seq(B, -1)
  for d in 0..<D:
    last[ans[d]] = d
    result += s[d][ans[d]]
    for i in 0..<B:
      result -= c[i] * (d - last[i])
  return result

proc generate():seq[int] =
  var
    last = Seq(B, -1)
    sat = Seq(B, 0)
    ans = Seq(0, 0)
  
  for d in 0..<D:
    max_val := -int.inf
    index := -1
    for i in 0..<B:
      let t = s[d][i] + int(sat[i].float * 0.3)
      if max_val < t:
        max_val = t
        index = i
    # update min_index
    ans.add(index)
    sat[index] = 0
    last[index] = d
    for i in 0..<B:
      sat[i] += c[i] * (d - last[i])
  return ans

var ans = generate()
const SIMULATE_TIME = 1.97
let
  C = SIMULATE_TIME * 10000.0
  startTime = 0.0

proc SA(ans:seq[int]) = 
  var
    score = eval(ans)
    tmpScore:int
    endTime = startTime + SIMULATE_TIME
    currentTime:float
  while currentTime < endTime:
    change := rnd.
    if ct mod 1000 == 0:
      let delta = epochTime() - t0
      if delta > 1.97:
        break
    var prev_ans = ans
    var prev_p = p
    for i in 0..<1:
      d := rand(0..<D)
      ans[d] = rand(0..<B)
    p = eval(ans)
    if prev_p < p:
      stderr.write("found: ", p, "prev: ", prev_p, "\n")
      discard
    else:
      swap(ans, prev_ans)
      swap(p, prev_p)

for a in ans:
  echo a + 1
