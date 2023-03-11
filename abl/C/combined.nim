# header {{{
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
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

var N:int
var M:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(M, 0)
  B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
#}}}

when not declared ATCODER_DSU_HPP:
  const ATCODER_DSU_HPP* = 1

  import std/sequtils

  type
    DSU* = ref object
      n: int
      par_or_siz: seq[int]

  proc initDSU*(n: int): DSU {.inline.} =
    return DSU(n: n, par_or_siz: newSeqWith(n, -1))

  proc leader*(self: DSU; a: int): int {.inline.} =
    ## Path compression
    if self.par_or_siz[a] < 0: return a
    self.par_or_siz[a] = self.leader(self.par_or_siz[a])
    return self.par_or_siz[a]

  proc same*(self: DSU; a, b: int): bool {.inline.} =
    self.leader(a) == self.leader(b)

  proc size*(self: DSU; a: int): int {.inline.} =
    - self.par_or_siz[self.leader(a)]

  proc merge*(self: DSU; a, b: int): int {.inline, discardable.} =

    var
      x = self.leader(a)
      y = self.leader(b)

    if x == y: return x
    if self.par_or_siz[x] > self.par_or_siz[y]: swap(x, y)
    self.par_or_siz[x] += self.par_or_siz[y]
    self.par_or_siz[y] = x
    return x

  proc groups*(self: DSU): seq[seq[int]] {.inline.} =
    var
      leaderBuf = newSeq[int](self.n)
      groupsize = newSeq[int](self.n)
    for i in 0 ..< self.n:
      leaderBuf[i] = self.leader(i)
      groupsize[leaderBuf[i]].inc
    result = (0 ..< self.n).mapIt(newSeqOfCap[int](groupsize[it]))
    for i, ldr in leaderBuf:
      result[ldr].add i
    result.keepItIf(it.len > 0)

proc main() =
  var uf = initDSU(N)
  for i in 0..<M:
    uf.merge(A[i], B[i])
  let t = uf.groups.len
  echo t - 1
  return

main()

