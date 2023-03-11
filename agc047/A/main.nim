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
var A:seq[string]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextString())
#}}}

import sequtils

# CumulativeSum2D {{{
type CumulativeSum2D[T] = object
  built: bool
  data: seq[seq[T]]

proc initCumulativeSum2D[T](W, H:int):CumulativeSum2D[T] = CumulativeSum2D[T](data: newSeqWith(W + 1, newSeqWith(H + 1, T(0))), built:false)
proc initCumulativeSum2D[T](data:seq[seq[T]]):CumulativeSum2D[T] =
  result = initCumulativeSum2D[T](data.len, data[0].len)
  for i in 0..<data.len:
    for j in 0..<data[i].len:
      result.add(i,j,data[i][j])
  result.build()

proc add[T](self:var CumulativeSum2D[T]; x, y:int, z:T) =
  let (x, y) = (x + 1, y + 1)
  if x >= self.data.len or y >= self.data[0].len: return
  self.data[x][y] += z

proc build[T](self:var CumulativeSum2D[T]) =
  self.built = true
  for i in 1..<self.data.len:
    for j in 1..<self.data[i].len:
      self.data[i][j] += self.data[i][j - 1] + self.data[i - 1][j] - self.data[i - 1][j - 1]

proc `[]`[T](self: CumulativeSum2D[T], rx, ry:Slice[int]):T =
  assert(self.built)
  let (gx, gy) = (rx.b+1, ry.b+1)
  let (sx, sy) = (rx.a, ry.a)
  return self.data[gx][gy] - self.data[sx][gy] - self.data[gx][sy] + self.data[sx][sy]
#}}}

let B = 19

proc main() =
  var
    v = newSeq[(int,int)]()
    cs = initCumulativeSum2D[int](B, B)
  for a in A:
    let d = a.find('.')
    var num, den: int
    if d == -1:
      den = 0
      num = parseInt(a)
    else:
      den = a.len - d - 1
      num = parseInt(a[0..<d] & a[d+1..<a.len])
    var n2, n5:int
    while num mod 2 == 0:
      n2.inc
      num = num div 2
    while num mod 5 == 0:
      n5.inc
      num = num div 5
    n2 += 9 - den
    n5 += 9 - den
    den = 9
    n2.min=18
    n5.min=18
    v.add((n2, n5))
    cs.add(n2, n5, 1)
  cs.build()
  var ans = 0
  for (n2,n5) in v:
    ans += cs[18 - n2..<B, 18 - n5..<B]
    if n2 * 2 >= 18 and n5 * 2 >= 18:
      ans.dec
  ans = ans div 2
  print ans
  return

main()

