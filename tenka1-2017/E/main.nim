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
var B:seq[int]
var C:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
#}}}

# Binary Indexed Tree {{{
type BinaryIndexedTree[T] = object
  data: seq[T]

proc initBinaryIndexedTree[T](sz:int):BinaryIndexedTree[T] = BinaryIndexedTree[T](data:newSeq[T](sz + 1))

proc sum[T](self:BinaryIndexedTree[T], k:int):T =
  var k = k + 1
  result = T(0)
  while k > 0:
    result += self.data[k]
    k -= (k and (-k))
proc `[]`[T](self: BinaryIndexedTree[T], s:Slice[int]):T =
  self.sum(s.b) - self.sum(s.a - 1)

proc add[T](self: var BinaryIndexedTree[T], k:int, x:T) =
  var k = k + 1
  while k < self.data.len:
    self.data[k] += x
    k += (k and (-k))
# }}}

import sugar

#{{{ findFirst(f, l..r), findLast(f, l..r)
proc valid_range(l, r, eps:float):bool =
  let d = r - l
  if d < eps: return true
  if l <= 0.0 and 0.0 <= r: return false
  return d < eps * min(abs(l), abs(r))

proc findFirst(f:(float)->bool, s: Slice[float], eps: float):float =
  var (l, r) = (s.a, s.b)
  if not f(r): return Inf
  while not valid_range(l, r, eps):
    let m = (l + r) * 0.5
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(float)->bool, s: Slice[float], eps: float):float =
  var (l, r) = (s.a, s.b)
  if not f(l): return -Inf
  while not valid_range(l, r, eps):
    let m = (l + r) * 0.5
    if f(m): l = m
    else: r = m
  return l
#}}}

let M = (((N * (N - 1)) div 2) + 1) div 2

var slope_v = newSeq[(float, int)](N)

var st = initBinaryIndexedTree[int](N)

proc calc(x:float):bool =
  var v = newSeq[(float, int)](N)
  for i in 0..<N:
    let b = (C[i].float - A[i].float * x) / B[i].float
    v[i] = (b, i)
  v.sort()
  var bid = newSeq[int](N)
  for i in 0..<N: bid[v[i][1]] = i
  var ans = 0
  st.data.fill(0)
  for i in 0..<N:
    let j = bid[slope_v[i][1]]
    ans += st.sum(j)
    st.add(j, 1)
  return ans >= M

proc main() =
  var ans = newSeq[float](2)
  for c in 0..<2:
    for i in 0..<N:slope_v[i] = (-A[i].float/B[i].float, i)
    slope_v.sort()
    ans[c] = calc.findFirst(-1e+9..1e+9, 1e-10)
    for i in 0..<N:swap(A[i], B[i])
  print ans[0], " ", ans[1]
  return

main()

