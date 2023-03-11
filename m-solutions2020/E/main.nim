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

var N:int
var X:seq[int]
var Y:seq[int]
var P:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  X = newSeqWith(N, 0)
  Y = newSeqWith(N, 0)
  P = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
    P[i] = nextInt()
#}}}

# enumerate_digits {{{
proc nextDigits(a:var seq[int], d:int or seq or array):bool =
  when d isnot int: doAssert(d.len == a.len)
  for i in 0..<a.len:
    a[i].inc
    let u = when d is int: d else: d[i]
    if a[i] < u: return true
    doAssert(a[i] == u)
    a[i] = 0
    if i == a.len - 1: return false

iterator enumerateDigits(n:int, d:int or seq or array):seq[int] =
  var a = newSeq[int](n)
  while true:
    yield a
    if not a.nextDigits(d): break
# }}}

proc main() =
  var ans0 = Seq(N + 1, int.inf)
  xs := newSeq[(int,int)]()
  ys := newSeq[(int,int)]()
  for i in 0..<N:
    xs.add((X[i], i))
    ys.add((Y[i], i))
  xs.sort()
  ys.sort()
  # id -> sorted
  var
    xid, yid = Array(16, int)
  # sorted -> id
  var
    xid_rev, yid_rev = Array(16, int)
  for i,p in xs: xid[p[1]] = i;xid_rev[i] = p[1]
  for i,p in ys: yid[p[1]] = i;yid_rev[i] = p[1]
  var
    xi, yi = Array(16, false)
    vertical, horizontal = Seq(2^N, N, int.inf)
  for b in 0..<2^N:
    for i in 0..<N: vertical[b][i] = abs(X[i])
    block:
      var prev = int.inf
      for i in countup(0, N - 1):
        let j = xid_rev[i]
        if b[j] == 1: prev = X[j]
        if prev != int.inf: vertical[b][j].min= X[j] - prev
    block:
      var prev = int.inf
      for i in countdown(N - 1, 0):
        let j = xid_rev[i]
        if b[j] == 1: prev = X[j]
        if prev != int.inf: vertical[b][j].min= prev - X[j]
  for b in 0..<2^N:
    for i in 0..<N: horizontal[b][i] = abs(Y[i])
    block:
      var prev = int.inf
      for i in countup(0, N - 1):
        let j = yid_rev[i]
        if b[j] == 1: prev = Y[j]
        if prev != int.inf: horizontal[b][j].min= Y[j] - prev
    block:
      var prev = int.inf
      for i in countdown(N - 1, 0):
        let j = yid_rev[i]
        if b[j] == 1: prev = Y[j]
        if prev != int.inf: horizontal[b][j].min= prev - Y[j]
  for dg in enumerateDigits(N, 3):
    var
      bv = 0
      bh = 0
      s = 0
      k = 0
    for i,d in dg:
      if d > 0: k.inc
      if d == 1: bv[i] = 1
      elif d == 2: bh[i] = 1
    for i in 0..<N:
      s += min(vertical[bv][i], horizontal[bh][i]) * P[i]
    ans0[k].min=s
  for d in ans0:
    print d
  return

main()
