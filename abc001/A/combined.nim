# header {{{
{.hints:off checks:off warnings:off assertions:on optimization:speed.}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
import strformat
import sugar
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

when true:
  const ATCODER_MODINT_HPP* = 1

  type
    ModInt*[M: static[int]] = distinct int

  proc `$`*[M: static[int]](m: ModInt[M]): string {.inline.} =
    $m.int

  proc `mod`*(x, y: int): int {.inline.} =
    ## requires: y > 0
    assert y > 0
    if x < 0:
      y - system.`mod`(-x, y)
    else:
      system.`mod`(x, y)

  proc extgcd*(x, y: int): (int, int) {.inline.} =
    var
      a = x
      p = y
      b, r = 1
      c, q = 0
    while a mod p != 0:
      let t = a div p
      a -= p * t
      b -= q * t
      c -= r * t
      swap(a, p)
      swap(b, q)
      swap(c, r)
    (q, r)

  proc initModInt*(v: int = 0; M: static[int] = 1_000_000_007): ModInt[M] {.inline.} =
    ModInt[M](v mod M)

  proc initModIntRaw*(v: int = 0; M: static[int] = 1_000_000_007): ModInt[M] {.inline.} =
    ModInt[M](v)

  proc retake*[M: static[int]](m: var ModInt[M]) {.inline.} =
    int(m) = int(m) mod M

  proc val*[M: static[int]](m: ModInt[M]): int {.inline.} =
    int(m)

  proc modulo*[M: static[int]](m: ModInt[M]): int {.inline.} =
    M

  proc `-`*[M: static[int]](m: ModInt[M]): ModInt[M] {.inline.} =
    ModInt[M](M - int(m))

  template generateDefinitions(name, l, r, retType, body: untyped): untyped =
    proc name*[M: static[int]](l: ModInt[M]; r: ModInt[M]): retType {.inline.} =
      body
    proc name*[M: static[int]](l: int; r: ModInt[M]): retType {.inline.} =
      body
    proc name*[M: static[int]](l: ModInt[M]; r: int): retType {.inline.} =
      body

  proc inv*[M: static[int]](m: ModInt[M]): ModInt[M] {.inline.} =
    result = initModInt(extgcd(M, int(m))[1], M)

  proc `+=`*[M: static[int]](m: var ModInt[M]; n: int | ModInt[M]) {.inline.} =
    int(m) += int(n)
    m.retake()

  proc `-=`*[M: static[int]](m: var ModInt[M]; n: int | ModInt[M]) {.inline.} =
    int(m) -= int(n)
    m.retake()

  proc `*=`*[M: static[int]](m: var ModInt[M]; n: int | ModInt[M]) {.inline.} =
    int(m) *= int(n)
    m.retake()

  proc `/=`*[M: static[int]](m: var ModInt[M]; n: int | ModInt[M]) {.inline.} =
    int(m) *= extgcd(M, n mod M)[1] mod M
    m.retake()

  generateDefinitions(`+`, m, n, ModInt[M]):
    result += m
    result += n

  generateDefinitions(`-`, m, n, ModInt[M]):
    result += m
    result -= n

  generateDefinitions(`*`, m, n, ModInt[M]):
    result += m
    result *= n

  generateDefinitions(`/`, m, n, ModInt[M]):
    result += m
    result /= n

  proc `==`*[M: static[int]](m: ModInt[M]; n: int | ModInt[M]): bool {.inline.} =
    int(m) == int(n)

  proc inc*[M: static[int]](m: var ModInt[M]) {.inline.} =
    int(m).inc
    if m == M:
      int(m) = 0

  proc dec*[M: static[int]](m: var ModInt[M]) {.inline.} =
    if m == 0:
      int(m) = M - 1
    else:
      int(m).dec

  proc pow*[M: static[int]](m: ModInt[M]; p: int): ModInt[M] {.inline.} =
    var
      p = p
      m = m
    int(result) = 1
    while p > 0:
      if (p and 1) == 1:
        result *= m
      m *= m
      p = p shr 1
  discard

var a = initModInt(19, 1000000007)
echo a + a

var H:seq[int]

# input part {{{
proc main()
block:
  H = newSeqWith(2, nextInt())
#}}}

proc main() =
  return

main()

