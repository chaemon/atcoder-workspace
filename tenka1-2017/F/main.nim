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

var Q:int
var A:seq[int]
var M:seq[int]

# input part {{{
proc main()
block:
  Q = nextInt()
  A = newSeqWith(Q, 0)
  M = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    M[i] = nextInt()
#}}}

#{{{ gcd and inverse
proc gcd(a,b:int):int=
  if b == 0: return a
  else: return gcd(b,a mod b)
proc lcm(a,b:int):int=
  return a div gcd(a, b) * b
# a x + b y = gcd(a, b)
proc extGcd(a,b:int, x,y:var int):int =
  var g = a
  x = 1
  y = 0
  if b != 0:
    g = extGcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g
proc invMod(a,m:int):int =
  var
    x,y:int
  if extGcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
#}}}

proc modPow[T](x,n,p:T):T =
  var (x,n) = (x,n)
  result = T(1)
  while n > 0:
    if (n and 1) > 0: result *= x; result = result mod p
    x *= x; x = x mod p
    n = (n shr 1)

proc eulerPhi(n:int):int =
  var
    n = n
    i = 2
  result = n
  while i * i <= n:
    if n mod i == 0:
      result -= result div i
      while n mod i == 0: n = n div i
    i += 1
  if n > 1: result -= result div n
  return result

# Tetration Mod {{{
proc tetration(a,b,m:int):int =
  proc MOD(a, m:int):int = (if a < m: a else: a mod m + m)
  proc power(n,k,m:int):int =
    var (n, k) = (n, k)
    result = MOD(1, m)
    while k > 0:
      if (k and 1).bool: result = MOD(result * n, m)
      n = MOD(n * n, m)
      k = k shr 1
  proc tetrationSub(a, b, m:int):int =
    if a == 0: return MOD((b + 1) mod 2, m)
    elif b == 0: return MOD(1, m)
    elif m == 1: return MOD(1, m)
    else: return power(a, tetrationSub(a, b - 1, eulerPhi(m)), m)
  return tetrationSub(a, b, m) mod m
# }}}

# linear congruence {{{
import options

proc linearCongruences[T](p:seq[tuple[a,b,m:T]]):Option[tuple[x,m:T]] =
  let n = p.len
  var
    x = T(0)
    M = T(1)
  for (a, b, m) in p:
    var
      m0 = m
      b0 = (b - a * x).floorMod m0
    var y, t:T
    let g = extGcd(a * M, m0, y, t)
    if (b0 mod g) != 0: return none(result.T)
    b0 = b0 div g
    m0 = m0 div g
    x += M * ((y * b0).floorMod m0)
    M *= m0
    x = x.floorMod M
  return (x, M).some
# }}}

proc calc(A, M:int) =
  if A == 0:
    print M;return
  var v = newSeq[tuple[a,b,m:int]]()
  v.add((1, tetration(A, 10^9, M), M))
  let pM = eulerPhi(M)
  v.add((1, tetration(A, 10^9, pM), pM))
  var t = linearCongruences(v)
  assert t.isSome
  let (x, m) = t.get
  var K = x
  while K < 64: K += m
  print K
#  assert(K mod M == v[0].b mod M)
#  assert(K mod pM == v[1].b mod pM)
#  assert(modPow(A, K, M) == K mod M)
  return

proc main() =
  for q in 0..<Q: calc(A[q], M[q])
  return

main()

