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
var K:int
var X:seq[int]
var Q:int
var L:seq[int]
var R:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  X = newSeqWith(N, nextInt())
  Q = nextInt()
  L = newSeqWith(Q, 0)
  R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt() - 1
#}}}

proc main() =
  var ans = newSeq[int](Q)
  for ct in 0..<2:
    var
      next = newSeq[int](N)
      l = 0
    for i in 0..<N:
      while l < N and X[l] - X[i] < K: l.inc
      next[i] = l
    const B = 18
    type P = tuple[i, s:int]
    var
      doubling = newSeqWith(B, newSeq[P](N))
    for i in 0..<N:
      var s:int = if next[i] < N: X[next[i]] else: int.inf
      doubling[0][i] = (next[i], next[i])
    for j in 1..<B:
      for i in 0..<N:
        var (i2,s) = doubling[j - 1][i]
        if i2 < N:
          s += doubling[j - 1][i2].s
          i2 = doubling[j - 1][i2].i
        doubling[j][i] = (i2, s)

    for q in 0..<Q:
      var
        i = L[q]
        n = 0
        s = 0
      for b in countdown(B - 1, 0):
        let d = (1 shl b)
        if doubling[b][i].i <= R[q]:
          n += d
          s += doubling[b][i].s
          i = doubling[b][i].i
      if ct == 0:
        ans[q] -= s
        ans[q] -= L[q]
        ans[q] += n + 1
      else:
        ans[q] += (n + 1) * (N - 1) - (s + L[q])
    var X2 = newSeq[int](N)
    for i in 0..<N:
      X2[i] = -X[N - 1 - i]
    swap(X, X2)
    for q in 0..<Q:
      var
        L2 = N - 1 - R[q]
        R2 = N - 1 - L[q]
      swap(L2, L[q])
      swap(R2, R[q])
  echo ans.join("\n")
  return

main()
