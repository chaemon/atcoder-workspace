# header {{{
{.hints:off warnings:off optimization:speed checks:off.}
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

var H:int
var W:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  H = nextInt()
  W = nextInt()
  A = newSeqWith(H, 0)
  B = newSeqWith(H, 0)
  for i in 0..<H:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
#}}}

import src/nim_acl/extra/structure/universal_segtree


proc main() =
  type D = int
  type L = (int, int)
  proc fDD(a, b:D):D = min(a, b)
  proc fDL(l:L, d:D):D =
    if l[1] == 0:
      return min(d + l[0], int.inf)
    else:
      assert l[1] == 1
      return l[0]
#  proc fLL(a, b:L):L = ## old, new
#    if b[1] > 0:
#      assert b[1] == 1
#      b
#    else:
#      (min(a[0] + b[0], int.inf), a[1])
  proc fLL(a, b:L):L = ## new, old
    if a[1] > 0:
      assert a[1] == 1
      a
    else:
      (min(b[0] + a[0], int.inf), b[1])

#  proc f_p(a:L, b:Slice[int]):L = a
  proc fp(a:L, b:Slice[int]):L =
    if a[0] >= int.inf: result = (int.inf, 0)
    else: result = (a[0] + b.a * a[1], a[1])
#    echo "fp: ", a, " ", b, " ", result
#  var st = initLazySegmentTree(W, fDD, fDL, fLL, int.inf, (0, 0))
  var st = initLazySegTree(W, fDD, ()=>int.inf, fDL, fLL, ()=>(0, 0), fp)
  for i in 0..<W:st.set(i, 0)
  for i in 0..<H:
    st.apply(0..<W, (1, 0))
    var t:int
    if A[i] == 0: t = int.inf
    else: t = st.get(A[i] - 1)
    st.apply(A[i]..B[i], (t + 1, 1))
    let a = st.prod(0..<W)
    if a == int.inf: echo -1
    else: echo a
main()
