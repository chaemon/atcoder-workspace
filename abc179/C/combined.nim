# {{{ header
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm
  import std/sequtils
  import std/tables
  import std/macros
  import std/math
  import std/sets
  import std/strutils
  import std/strformat
  import std/sugar
  
  import streams
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  #proc getchar(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(): int = scanf("%lld",addr result)
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*[F](f:F): string =
    var get = false
    result = ""
    while true:
  #    let c = getchar()
      let c = f.readChar
      if c.int > ' '.int:
        get = true
        result.add(c)
      elif get: return
  proc nextInt*[F](f:F): int = parseInt(f.nextString)
  proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
  proc nextString*():string = stdin.nextString()
  
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  
  proc discardableId*[T](x: T): T {.discardable.} =
    return x
  
  macro `:=`*(x, y: untyped): untyped =
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
  
  
  proc toStr*[T](v:T):string =
    proc `$`[T](v:seq[T]):string =
      v.mapIt($it).join(" ")
    return $v
  
  proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
    result = ""
    for i,v in x:
      if i != 0: addSep(result, sep = sep)
      add(result, v)
    result.add("\n")
    stdout.write result
  
  var print*:proc(x: varargs[string, toStr])
  print = proc(x: varargs[string, toStr]) =
    discard print0(@x, sep = " ")
  
  template makeSeq*(x:int; init):auto =
    when init is typedesc: newSeq[init](x)
    else: newSeqWith(x, init)
  
  macro Seq*(lens: varargs[int]; init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
    parseStmt(fmt"""  
block:
  {a}""")
  
  template makeArray*(x:int; init):auto =
    var v:array[x, init.type]
    when init isnot typedesc:
      for a in v.mitems: a = init
    v
  
  macro Array*(lens: varargs[typed], init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0):
      a = fmt"makeArray({lens[i].repr}, {a})"
    parseStmt(fmt"""
block:
  {a}""")
# }}}
  discard

var N:int

# input part {{{
proc main()
block:
  N = nextInt()
#}}}

#{{{ sieve_of_eratosthenes
when not defined ATCODER_ERATOSTHENES_HPP:
  const ATCODER_ERATOSTHENES_HPP = 1
  type Eratosthenes* = object
    pdiv:seq[int]
  
  proc initEratosthenes*(n:int):Eratosthenes =
    var pdiv = newSeq[int](n + 1)
    for i in 2..n:
      pdiv[i] = i;
    for i in 2..n:
      if i * i > n: break
      if pdiv[i] == i:
        for j in countup(i*i,n,i):
          pdiv[j] = i;
    return Eratosthenes(pdiv:pdiv)
  proc isPrime*(self:Eratosthenes, n:int): bool =
    return n != 1 and self.pdiv[n] == n
  proc factor*(self:Eratosthenes, n:int): seq[(int,int)] =
    result = newSeq[(int,int)]()
    var n = n
    while n > 1:
      let p = self.pdiv[n]
      var e = 0
      while n mod p == 0: e.inc;n = n div p
      result.add (p, e)
#}}}

proc main() =
  var es = initEratosthenes(10^7)
  var ans = 0
  for C in 1..<N:
    let p = N - C
    var f = es.factor(p)
    var e = initTable[int,int]()
    var t = 1
    for (k,v) in f:
      t *= v + 1
    ans += t
  print ans
  return

main()

