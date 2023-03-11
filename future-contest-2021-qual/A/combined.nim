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
    template `min=`*(x,y:typed):void = x = min(x,y)
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

proc moveTo(ans:var string, f:(int,int), t:(int, int)) =
  let (fx, fy) = f
  let (tx, ty) = t
  let dx = abs(fx - tx)
  if fx < tx:
    ans &= "D".repeat(dx)
  else:
    ans &= "U".repeat(dx)
  let dy = abs(fy - ty)
  if fy < ty:
    ans &= "R".repeat(dy)
  else:
    ans &= "L".repeat(dy)

proc solve(x:seq[int], y:seq[int]) =
  let B = 20
  let B2 = B div 2
  let N = 100
  var ans = ""
  var a = Seq(B, B, -1)
  for i in 0..<N:a[x[i]][y[i]] = i
  var x0, y0 = 0
  var st = newSeq[int]()
  while true:
    if x0 >= B:break
    if a[x0][y0] >= 0:
      st.add a[x0][y0]
      a[x0][y0] = -1
      ans &= "I"
    if st.len == N:break
    if x0 mod 2 == 0:
      y0.inc
      if y0 >= B:
        y0 = B - 1
        x0.inc
        ans &= "D"
      else:
        ans &= "R"
    else:
      y0.dec
      if y0 < 0:
        y0 = 0
        x0.inc
        ans &= "D"
      else:
        ans &= "L"
  assert st.len == N
  let
    baseX = B2
    baseY = 0
  while st.len > 0:
    let u = st.pop()
    let x = u div B2 + baseX
    var y = u mod B2 + baseY
    if x mod 2 == 1: y = B2 - 1 - y
    moveTo(ans, (x0, y0), (x, y))
    ans &= "O"
    a[x][y] = u
    (x0, y0) = (x, y)
  moveTo(ans, (x0, y0), (baseX, baseY))
  x0 = baseX
  y0 = baseY
  while true:
    if x0 >= B:break
    if a[x0][y0] >= 0:
      st.add a[x0][y0]
      a[x0][y0] = -1
      ans &= "I"
    if st.len == N:break
    if x0 mod 2 == 0:
      y0.inc
      if y0 >= B2:
        y0 = B2 - 1
        x0.inc
        ans &= "D"
      else:
        ans &= "R"
    else:
      y0.dec
      if y0 < 0:
        y0 = 0
        x0.inc
        ans &= "D"
      else:
        ans &= "L"
  echo ans
  return

# input part {{{
block:
  var x = newSeqWith(99-0+1, 0)
  var y = newSeqWith(99-0+1, 0)
  for i in 0..<99-0+1:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
#}}}
