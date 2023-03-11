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


proc solve() =
  let T = nextInt()
  for _ in 0..<T:
    let N = nextInt()
    let A = newSeqWith(N, nextInt())
    var ldp, rdp = Seq(N, N, -1)
    if N == 1:
      echo "First";continue
    proc R(i, j:int):int
    proc L(i, j:int):int =
      if i > j: return 0
      if ldp[i][j] >= 0: return ldp[i][j]
      let b = A[j]
      let Rw = R(i, j - 1)
      if b <= Rw: result = 0
      else: result = L(i, j - 1) - Rw + b
      ldp[i][j] = result
    proc R(i, j:int):int =
      if i > j: return 0
      if rdp[i][j] >= 0: return rdp[i][j]
      let a = A[i]
      let Lw = L(i + 1, j)
      if a <= Lw: result = 0
      else: result = R(i + 1, j) - Lw + a
      rdp[i][j] = result
    let
      a = A[0]
      b = A[^1]
      Lw = L(1, N - 2)
      Rw = R(1, N - 2)
    if a <= Lw and b <= Rw: # N
      echo "First";continue
    let c = a - Lw
    if c > 0 and a == Lw + c and b == Rw + c: # P
      echo "Second";continue
    if c > 0 and a == Lw + c and b < Rw + c: # L
      echo "First";continue
    echo "Second"
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
