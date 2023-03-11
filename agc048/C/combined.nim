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


proc solve(N:int, L:int, A:seq[int], B:seq[int]) =
  if N == L:
    echo 0
    return
  var
    ans = 0
    l = 0
    r = L - 1
    li = 0
    ri = N - 1
  while B[li] == l:
    if A[li] != l:ans.inc
    l.inc
    li.inc
  while B[ri] == r:
    if A[ri] != r: ans.inc
    r.dec
    ri.dec
  # consider li..ri
  if li > ri:
    echo ans
    return
  var rs = newSeq[Slice[int]]()
  var i = li
  while i <= ri:
    var j = i + 1
    while j <= ri and B[j - 1] + 1 == B[j]: j.inc
    # index i..<j is consective
    var c = 0
    for k in i..<j:
      if A[k] == B[k]:c.inc
    if c > 0:
      ans += j - i - c
    else:
      rs.add(i..<j)
#      if B[i] < A[i]: # do left
#        if i == 0 or A[i - 1] != B[i] - 1: echo -1;return
#        # valid!!
#      elif B[j - 1] > A[j - 1]:
#        if j == N or A[j] != B[j - 1] + 1: echo -1;return
#        # valid!!
#      else:
#        echo -1;return
#      ans += j - i
    i = j
#  echo rs
  var ans_rs = newSeqWith(rs.len, int.inf)
  block:
    var
      tbl = initTable[int,int]() # diff, index
      t = 0
    for i in 0..<N:
      if i == rs[t].a:
        if B[i] < A[i]: # do left
          if i - B[i] in tbl:
            ans_rs[t].min= rs[t].len + (i - 1 - tbl[i - B[i]])
        else:
          # cannot do left
          discard
        t.inc
      tbl[i - A[i]] = i
  block:
    var
      tbr = initTable[int,int]() # diff, index
      t = rs.len - 1
    for i in countdown(N - 1, 0):
      if i == rs[t].b:
        if A[i] < B[i]: # do right
          if i - B[i] in tbr:
            ans_rs[t].min= rs[t].len + (tbr[i - B[i]] - i - 1)
        else:
          # cannot do left
          discard
        t.dec
      tbr[i - A[i]] = i
#  echo ans_rs
  for p in ans_rs:
    if p == int.inf: echo -1;return
    ans += p
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var L = nextInt()
  var A = newSeqWith(N, nextInt() - 1)
  var B = newSeqWith(N, nextInt() - 1)
  solve(N, L, A, B)
#}}}
