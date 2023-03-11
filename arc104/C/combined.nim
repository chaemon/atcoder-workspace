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

const YES = "Yes"
const NO = "No"
var N:int
var A:seq[int]
var B:seq[int]

# input part {{{
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    if A[i] >= 0: A[i].dec
    if B[i] >= 0: B[i].dec
#}}}

block main:
  var left = newSeqWith(N * 2, -1)
  var right = newSeqWith(N * 2, -1)
  var A_exist = newSeqWith(N * 2, false)
  var B_exist = newSeqWith(N * 2, false)
  var reserved = newSeqWith(N * 2, -1)
  proc check(i, j:int):bool =
    if A_exist[i]:
      if right[i] != -1:
        if right[i] != j: return false
      else:
        if A_exist[j] or B_exist[j]: return false
    if B_exist[j]:
      if left[j] != -1:
        if left[j] != i: return false
      else:
        if A_exist[i] or B_exist[i]: return false
    let C = j - i + 1
#    if reserved[i] != -1 and reserved[i] != C: return false
#    if reserved[j] != -1 and reserved[j] != C: return false
    for k in i..j:
      if reserved[k] != -1 and reserved[k] != C: return false
    return true

  for i in 0..<N:
    if A[i] >= 0 and B[i] >= 0 and A[i] >= B[i]:
      echo NO
      break main
    if A[i] != -1:
      if A_exist[A[i]]: echo NO;break main
      A_exist[A[i]] = true
    if B[i] != -1:
      if B_exist[B[i]]: echo NO;break main
      B_exist[B[i]] = true
    if A[i] != -1 and B[i] != -1:
      left[B[i]] = A[i]
      right[A[i]] = B[i]
      let C = B[i] - A[i] + 1
      for j in A[i]..B[i]:
        if reserved[j] != -1 and reserved[j] != C: echo NO;break main
        reserved[j] = C
  var dp = newSeq[bool](N * 2 + 1)
  dp[0] = true
  for i in countup(0, N * 2 - 1, 2):
    if not dp[i]: continue
    for k in 1..N:
      # i -> i + k
      # i + 1 -> i + k + 1
      # ...
      # i + k - 1 -> i + k * 2 - 1
      if i + k * 2 > N * 2: break
      var valid = true
      for j in 0..k - 1:
        if not check(i + j, i + j + k):valid = false
      if valid:
#        echo i, " -> ", i + k * 2
        dp[i + k * 2] = true
  if dp[N * 2]:
    echo YES
  else:
    echo NO
  break
