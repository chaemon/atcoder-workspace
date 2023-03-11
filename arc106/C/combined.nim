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

proc intersect(p, q:(int,int)):bool =
  return p[0] <= q[1] and q[0] <= p[1]

proc aoki(ans:seq[(int,int)]):int =
  var ans = ans
  ans.sort() do (p, q:(int,int)) -> int:
    cmp[int](p[0], q[0])
  var v = newSeq[(int,int)]()
  for i in 0..<ans.len:
    var valid = true
    for p in v:
      if intersect(p, ans[i]):valid = false;break
    if valid: v.add(ans[i])
  return v.len

proc takahashi(ans:seq[(int,int)]):int =
  var ans = ans
  ans.sort() do (p, q:(int,int)) -> int:
    cmp[int](p[1], q[1])
  var v = newSeq[(int,int)]()
  for i in 0..<ans.len:
    var valid = true
    for p in v:
      if intersect(p, ans[i]):valid = false;break
    if valid: v.add(ans[i])
  return v.len

proc solve(N:int, M:int) =
  if N == 1:
    if M == 0:
      echo "1 10"
    else:
      echo -1
    return
  elif M < 0:
    echo -1
    return
#    let T = M + 1 # takahashi: M + 1, aoki: 1
#    ans.add((1, 10^8 - 1))
#    var l = 2
#    for i in 0..<T - 1:
#      ans.add((l, l + 1))
#      l += 2
#    var r = 10^8
#    for i in 0..<N - T:
#      ans.add((l, r))
#      l.inc
#      r.inc
  elif M > N - 2:
    echo -1;
    return
  var ans = newSeq[(int,int)]()
#    var M = -M
  ans.add((1, 10^8 - 1))
  let A = M + 1 # aoki: 1, takahashi: M + 1
  var l = 2
  for i in 0..<A-1:
    ans.add((l, l + 1))
    l += 2
  var r = 10^8 - 1 - 1
  for i in 0..<N - A:
    ans.add((l, r))
    l.inc
    r.dec
  for (x, y) in ans:
    echo x, " ", y
  when false:
    var st = initSet[int]()
    for (x, y) in ans:
      assert 1 <= x and x <= 10^9
      assert 1 <= y and y <= 10^9
      assert x notin st
      st.incl(x)
      assert y notin st
      st.incl(x)
    assert takahashi(ans) - aoki(ans) == M
  return

#proc test() =
#  for N in 1..100:
#    for M in -N..N:
#      echo "test: ", N, " ", M
#      solve(N, M)
#  echo "test_end"

#test()

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}
