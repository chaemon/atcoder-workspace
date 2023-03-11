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
  
  when not declared ATCODER_READER_HPP:
    const ATCODER_READER_HPP* = 1
    import streams
    import strutils
    import sequtils
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
    discard
  when not declared ATCODER_SLICEUTILS_HPP:
    const ATCODER_SLICEUTILS_HPP* = 1
    proc index*[T](a:openArray[T]):Slice[int] =
      a.low..a.high
    type ReversedSlice[T] = distinct Slice[T]
    type StepSlice[T] = object
      s:Slice[T]
      d:T
    proc reversed*[T](p:Slice[T]):auto = ReversedSlice[T](p)
    iterator items*(n:int):int = (for i in 0..<n: yield i)
    iterator items*[T](p:ReversedSlice[T]):T =
      var i = Slice[T](p).b
      while true:
        yield i
        if i == Slice[T](p).a:break
        i.dec
    proc `>>`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d:d)
    proc `<<`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d: -d)
    proc low*[T](s:StepSlice[T]):T = s.s.a
    proc high*[T](s:StepSlice[T]):T =
      let p = s.s.b - s.s.a
      if p < 0: return s.low - 1
      let d = abs(s.d)
      return s.s.a + (p div d) * d
    iterator items*[T](p:StepSlice[T]):T = 
      assert p.d != 0
      if p.s.a <= p.s.b:
        if p.d > 0:
          var i = p.low
          let h = p.high
          while true:
            yield i
            if i == h: break
            i += p.d
        else:
          var i = p.high
          let l = p.low
          while true:
            yield i
            if i == l: break
            i += p.d
    proc `[]`*[T:SomeInteger, U](a:openArray[U], s:Slice[T]):seq[U] =
      for i in s:result.add(a[i])
    proc `[]=`*[T:SomeInteger, U](a:var openArray[U], s:StepSlice[T], b:openArray[U]) =
      var j = 0
      for i in s:
        a[i] = b[j]
        j.inc
    discard
  when not declared ATCODER_MAX_MIN_OPERATOR_HPP:
    const ATCODER_MAX_MIN_OPERATOR_HPP* = 1
    template `max=`*(x,y:typed):void = x = max(x,y)
    template `>?=`*(x,y:typed):void = x.max= y
    template `min=`*(x,y:typed):void = x = min(x,y)
    template `<?=`*(x,y:typed):void = x.min= y
    discard
  when not declared ATCODER_INF_HPP:
    const ATCODER_INF_HPP* = 1
    template inf*(T): untyped = 
      when T is SomeFloat: T(Inf)
      elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
      else:
        static: assert(false)
    discard
  when not declared ATCODER_CHAEMON_WARLUS_OPERATOR_HPP:
    const ATCODER_CHAEMON_WARLUS_OPERATOR_HPP* = 1
    import strformat
    import macros
    proc discardableId*[T](x: T): T {.discardable.} = x
  
    macro `:=`*(x, y: untyped): untyped =
      var strBody = ""
      if x.kind == nnkPar:
        for i,xi in x:
          strBody &= fmt"""{'\n'}{xi.repr} := {y[i].repr}{'\n'}"""
      else:
        strBody &= fmt"""{'\n'}when declaredInScope({x.repr}):{'\n'}  {x.repr} = {y.repr}{'\n'}else:{'\n'}  var {x.repr} = {y.repr}{'\n'}"""
      strBody &= fmt"discardableId({x.repr})"
      parseStmt(strBody)
    discard
  when not declared ATCODER_SEQ_ARRAY_UTILS:
    const ATCODER_SEQ_ARRAY_UTILS* = 1
    import strformat
    import macros
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
    discard
  when not declared ATCODER_DEBUG_HPP:
    const ATCODER_DEBUG_HPP* = 1
    import macros
    import strformat
    import terminal
    macro debug*(n: varargs[untyped]): untyped =
    #  var a = "stderr.write "
      var a = ""
      a.add "setForegroundColor fgYellow\n"
      a.add "echo "
      for i,x in n:
        a = a & fmt""" "{x.repr} = ", {x.repr} """
        if i < n.len - 1:
          a.add(""", ", ",""")
      a.add "\n"
      a.add "resetAttributes()"
      parseStmt(a)
    discard

import BigNum

var first = true

var ans_naive = initTable[int,int]()

proc solve_naive(D:int):int =
  if first:
    for N in 1..10000000:
      var d = newSeq[int]()
      var N2 = N
      while N2 > 0:
        d.add(N2 mod 10)
        N2 = N2 div 10
      var d2 = d
      d2.reverse
      var revN = 0
      var p = 1
      for d in d2:
        revN += d * p
        p *= 10
      let D = revN - N
      if D notin ans_naive:
        ans_naive[D] = 0
      ans_naive[D].inc
  first = false
  return if D in ans_naive: ans_naive[D] else: 0

proc solve(D:int) =
  const B = 30
  var
    p10 = newSeq[Int]()
    p = newInt(1)
  for i in B + 1:
    p10.add(p.clone())
    if i == B: break
    p *= 10
  proc calc_pattern(t:int, start:bool):int =
    assert abs(t) < 10
    # rev(N) - N
    if start and t >= 0:
      return 10 - t - 1
    else:
      return 10 - abs(t)
  proc calc(d:int):Int =
    var
      s = 0
      t = d - s
      dp = newSeq[(Int,Int)]()
    dp.add((newInt(D), newInt(1)))
    while s <= t:
      var dp2 = newSeq[(Int,Int)]()
      let p = p10[t - s] - 1
#      debug p
#      debug dp
      let start = if s == 0: true else: false
      for (D, n) in dp:
        var r = (toInt((-D) mod 10) + 10) mod 10
        if r > 0: r -= 10
        let T = D - r * p
        if T mod 10 == 0:
          let 
            D2 = T div 10
            n2 = n * calc_pattern(r, start)
#          debug D, n, r, D2, n2
          dp2.add((D2, n2))
        if r != 0:
          r += 10
          let T = D - r * p
          if T mod 10 == 0:
            let 
              D2 = T div 10
              n2 = n * calc_pattern(r, start)
#            debug D, n, r, D2, n2
            dp2.add((D2, n2))
#        debug dp2
      s.inc
      t.dec
      swap dp, dp2
#    debug dp
    result = newInt(0)
    for (D, n) in dp:
      if D == newInt(0):
        result += n
#    debug d, result
  var ans = newInt(0)
  for d in 1..B:
    ans += calc(d)
#  let ans_naive = solve_naive(D)
#  debug ans, ans_naive
#  assert ans == ans_naive
  echo ans

proc test() =
  for D in 1..10000:
#  for D in 9..9:
    echo "D = ", D
    solve(D)

# input part {{{
block:
#  test()
  var D = nextInt()
  solve(D)
#}}}
