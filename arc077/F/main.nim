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

var S:string
var l:int
var r:int

# input part {{{
proc main()
block:
  S = nextString()
  l = nextInt()
  r = nextInt()
#}}}

# rolling hash {{{
import sequtils

const MOD = 1000000007'u

type RollingHash = object
  hashed, power: seq[uint]

proc mul(a,b:uint):uint =
  return (a * b) mod MOD

proc initRollingHash(s:string, base = 10007'u):RollingHash =
  var
    sz = s.len
    hashed = newSeqWith(sz + 1, 0'u)
    power = newSeqWith(sz + 1, 0'u)
  power[0] = 1'u
  for i in 0..<sz:
    power[i + 1] = mul(power[i], base);
    hashed[i + 1] = mul(hashed[i], base) + uint(s[i].ord)
    if hashed[i + 1] >= MOD: hashed[i + 1] -= MOD
  return RollingHash(hashed: hashed, power: power)

proc `[]`(self: RollingHash; s:Slice[int]):uint =
  result = self.hashed[s.b+1] + MOD - mul(self.hashed[s.a], self.power[s.b-s.a+1])
  if result >= MOD: result -= MOD

proc connect(self: RollingHash; h1, h2:uint, h2len:int):uint =
  result = mul(h1, self.power[h2len]) + h2
  if result >= MOD: result -= MOD

proc LCP(self, b:RollingHash; l1, r1, l2, r2:int):int =
  var
    len = min(r1 - l1, r2 - l2)
    low = -1
    high = len + 1
  while high - low > 1:
    let mid = (low + high) div 2
    if self[l1..<l1 + mid] == b[l2..<l2 + mid]: low = mid
    else: high = mid
  return low
# }}}

var s:string

proc count(s:string):array[26, int] =
  for c in s:
    result[c.ord - 'a'.ord].inc

proc count(n:int):array[26, int] =
  let
    q = n div s.len
    r = n mod s.len
  result = s.count()
  for it in result.mitems: it *= q
  let v = s[0..<r].count()
  for i in 0..<result.len: result[i] += v[i]

proc naive(s:string):string =
  rh := s.initRollingHash()
  proc test(l:int):bool =
    if (s.len + l) mod 2 != 0: return false
    let n = (s.len + l) div 2
    let t = n - l
    return rh[0..<t] == rh[s.len - t..<s.len]
  var L = 1
  while not test(L): L.inc
  result = s[0..<(s.len + L) div 2]
  result &= result

proc main() =
  var S2 = S
  for i in 0..<30:
    S2 = S2.naive()
    dump(S2.len)
  s = S2
#  let N = S.len
#  rh := S.initRollingHash()
#  proc test(l:int):bool =
#    if (S.len + l) mod 2 != 0: return false
#    let n = (N + l) div 2
#    let t = n - l
#    return rh[0..<t] == rh[N - t..<N]
#  var L = 1
#  while not test(L): L.inc
#  s = S[0..<(N + L) div 2]
#  dump(s)
  var v = count(r)
  var w = count(l - 1)
  for i in 0..<v.len:
    v[i] -= w[i]
  print v
  return


main()

