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
import sequtils

# DualCumulativeSum2D(imos) {{{
type DualCumulativeSum2D*[T] = object
  X, Y:int
  built: bool
  data: seq[seq[T]]

proc init*[T](self:var DualCumulativeSum2D[T], X, Y:int) =
  self.X = X
  self.Y = Y
  self.built = false
  if self.data.len < X + 1 or self.data[0].len < Y + 1:
    self.data = newSeqWith(X + 1, newSeqWith(Y + 1, T(0)))
  else:
    for x in 0..<X+1:
      for y in 0..<Y+1:
        self.data[x][y] = T(0)

proc initDualCumulativeSum2D*[T](X, Y:int):DualCumulativeSum2D[T] =
  result.init(X, Y)

#proc initDualCumulativeSum2D[T](data:seq[seq[T]]):CumulativeSum2D[T] =
#  result = initCumulativeSum2D[T](data.len, data[0].len)
#  for i in 0..<data.len:
#    for j in 0..<data[i].len:
#      result.add(i,j,data[i][j])
#  result.build()

proc add*[T](self:var DualCumulativeSum2D[T]; p:(Slice[int], Slice[int]), z:T) =
  assert not self.built
  let (rx, ry) = p
  let (gx, gy) = (rx.b + 1, ry.b + 1)
  let (sx, sy) = (rx.a, ry.a)
  self.data[gx][gy] += z
  self.data[sx][gy] -= z
  self.data[gx][sy] -= z
  self.data[sx][sy] += z

proc build*[T](self:var DualCumulativeSum2D[T]) =
  self.built = true
  for i in 1..<self.data.len:
    for j in 0..<self.data[0].len:
      self.data[i][j] += self.data[i - 1][j]
  for j in 1..<self.data[0].len:
    for i in 0..<self.data.len:
      self.data[i][j] += self.data[i][j - 1]

proc `[]`*[T](self: DualCumulativeSum2D[T], p:(int, int)):T =
  assert(self.built)
#  let (x, y) = (x + 1, y + 1)
  let (x, y) = p
  if x >= self.data.len or y >= self.data[0].len: return T(0)
  return self.data[x][y]

proc write*[T](self: DualCumulativeSum2D[T]) =
  assert(self.built)
  for i in 0..<self.X:
    for j in 0..<self.Y:
      stdout.write(self[i,j])
    echo ""
#}}}

# dump {{{
import macros
import strformat
import terminal

macro dump*(n: varargs[untyped]): untyped =
#  var a = "stderr.write "
  var a = "stdout.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

when not declared ATCODER_BINARY_SEARCH_HPP:
  const ATCODER_BINARY_SEARCH_HPP* = 1
  import sugar

  proc findMin*(f:(int)->bool, s:Slice[int]):int =
    var (l, r) = (s.a - 1, s.b)
    if not f(r): return s.b + 1
    while r - l > 1:
      let m = (l + r) shr 1
      if f(m): r = m
      else: l = m
    return r
  proc findMax*(f:(int)->bool, s:Slice[int]):int =
    var (l, r) = (s.a, s.b + 1)
    if not f(l): return s.a - 1
    while r - l > 1:
      let m = (l + r) shr 1
      if f(m): l = m
      else: r = m
    return l

proc addRect(cs:var DualCumulativeSum2D, p:(Slice[int], Slice[int]), d:int, D:int) =
  let (x, y) = p
  let
    xv = if x.a >= 0:
      @[x]
    elif x.b >= 0:
      @[x.a+D..<D, 0..x.b]
    else:
      @[x.a+D..x.b+D]
    yv = if y.a >= 0:
      @[y]
    elif y.b >= 0:
      @[y.a+D..<D, 0..y.b]
    else:
      @[y.a+D..y.b+D]
  for x in xv:
    for y in yv:
      cs.add((x, y), d)

proc solve(N:int, D:int, x:seq[int], y:seq[int]) =
  var a = Seq(D, D, 0)
  for i in 0..<N:
    a[x[i] mod D][y[i] mod D].inc
  var t = 0
  for i in 0..<D:
    t.max=a[i].max
  var k = 0
  while true:
    if t in k^2 + 1..(k + 1)^2:break
    k.inc
  var cs:DualCumulativeSum2D[int]
  proc test(r:int):bool =
    if r == 0: return false
    if r == D: return true
    cs.init(D, D)
    for x in 0..<D:
      for y in 0..<D:
        if a[x][y] > k * (k + 1):
          cs.add((0..<D, 0..<D), 1)
          cs.addRect((x-r+1..x, y-r+1..y), -1, D)
        elif a[x][y] > k * k:
          cs.addRect((x-D+1..x-r, y-D+1..y-r), 1, D)
    cs.build()
    for x in 0..<D:
      for y in 0..<D:
        if cs[(x, y)] == 0: return true
    return false
  let r = findMin(test, 0..D)
  echo r + k * D - 1
  return

# input part {{{
block:
  var N = nextInt()
  var D = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, D, x, y)
#}}}
