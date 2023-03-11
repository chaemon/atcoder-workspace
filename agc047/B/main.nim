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
var S:seq[string]

# input part {{{
proc main()
block:
  N = nextInt()
  S = newSeqWith(N, nextString())
#}}}

# default-table {{{
import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, B.default)
  tables.`[]`(self, key)
#}}}

# {{{ Rolling Hash
import sequtils

# {{{ RH
template MASK(n:static[int]):auto = (1'u shl n.uint) - 1

const base = 1000000007'u

type RH_Base[Mod:static[uint], base:static[uint]] = object
  h:uint

type RH = RH_Base[(1'u shl 61) - 1, base]

converter toRH(t:SomeInteger or char):RH = RH(h:t.uint)

proc multRaw(a, b:RH):RH =
  let
    au = a.h shr 31
    ad = a.h and MASK(31)
    bu = b.h shr 31
    bd = b.h and MASK(31)
    mid = ad * bu + au * bd
    midu = mid shr 30
    midd = mid and MASK(30)
  RH(h:au * bu * 2 + midu + (midd shl 31) + ad * bd)

proc calcMod[T:RH](x:T):T =
  let
    xu = x.h shr 61
    xd = x.h and MASK(61)
  result = RH(xu + xd)
  if result.h >= T.Mod: result.h -= T.Mod

proc `*=`(a: var RH, b:RH) =  a = calcMod(multRaw(a, b))
proc `*`(a, b:RH):RH = result = a;result *= b
proc `==`(a, b:RH):bool = a.h == b.h
proc `+=`(a:var RH, b:RH) =
  a.h += b.h
  if a.h >= RH.Mod: a.h -= RH.Mod
proc `+`(a, b:RH):RH = result = a;result += b
proc `-=`(a:var RH, b:RH) =
  a.h += RH.Mod - b.h
  if a.h >= RH.Mod: a.h -= RH.Mod
proc `-`(a, b:RH):RH = result = a;result -= b
proc `&=`(a:var RH, c:SomeInteger or char) =
  a = multRaw(a, RH(base))
  a += RH(c)
  a = a.calcMod()
proc `&`(a:RH, c:SomeInteger or char):RH = result = a;result &= c

import hashes
proc hash(a:RH):Hash = a.h.hash
# }}}

type RollingHash[RH] = object
  hashed, power: seq[RH]

proc initRollingHash(s:string):auto =
  var
    sz = s.len
    hashed = newSeqWith(sz + 1, RH(0))
    power = newSeqWith(sz + 1, RH(0))
  power[0] = 1'u
  for i in 0..<sz:
    power[i + 1] = RH(power[i]) * RH(base)
    hashed[i + 1] = calcMod(multRaw(hashed[i], RH(base)) + RH(s[i]))
#    if hashed[i + 1] >= MOD: hashed[i + 1] -= MOD
  return RollingHash[RH](hashed: hashed, power: power)

proc `[]`(self: RollingHash; s:Slice[int]):RH =
  result = RH(self.hashed[s.b+1].h + (RH.MOD shl 2) - multRaw(self.hashed[s.a], self.power[s.len]).h)
  result = result.calcMod()

proc connect(self: RollingHash; h1, h2:uint, h2len:int):RH =
  result = multRaw(RH(h1), self.power[h2len]) + RH(h2)
  result = result.calcMod

proc LCP(self, b:RollingHash; p1, p2:Slice[int]):int =
  var
    len = min(p1.len, p2.len)
    low = -1
    high = len + 1
  while high - low > 1:
    let mid = (low + high) div 2
    if self.get(p1.a..<p1.a + mid) == b.get(p2.a..<p2.a + mid): low = mid
    else: high = mid
  return low
# }}}

import sequtils

var rh = initRollingHash("hogehoge")
echo rh[3..4]

var tb = initTable[(int, RH), array[26, int]]()

proc calc_hash(s:string, p:Slice[int]):auto =
  result = RH(0)
  for i in countdown(p.b, p.a): result &= s[i]

proc main() =
#  for i in 0..<tb.len: tb[i] = initTable[uint, int]()

  for i in 0..<N:
    var p = S[i][0].ord - 'a'.ord
    var l = S[i].len - 1
    let h = calc_hash(S[i], 1..<S[i].len)
    if (l, h) notin tb:
      tb[(l, h)] = Array(26, 0)
    tb[(l, h)][p].inc

  var ans = 0
  for s in S:
    var
      hs = newSeq[RH](s.len + 1)
      h = RH(0)
    hs[s.len] = h
    for i in countdown(s.len - 1, 0):
      h &= s[i]
      hs[i] = h
    var pref = Array(26, false)
    for i in 0..<s.len:
      pref[s[i].ord - 'a'.ord] = true
      # i + 1..<s.len
      let l = s.len - (i + 1)
      let h = hs[i + 1]
      if (l, h) notin tb: continue
      for i,a in tb[(l, h)]:
        if pref[i]:
          ans += a
  ans -= N
  print ans
  return

main()

