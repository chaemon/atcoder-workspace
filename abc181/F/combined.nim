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

import complex

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
when not declared ATCODER_BINARY_SEARCH_FLOAT_HPP:
  const ATCODER_BINARY_SEARCH_FLOAT_HPP* = 1
  import sugar
  import math

  proc valid_range(l, r, eps:float):bool =
    let d = r - l
    if d < eps: return true
    if l <= 0.0 and 0.0 <= r: return false
    return d < eps * min(abs(l), abs(r))
  proc findMin*(f:(float)->bool, s: Slice[float], eps = 1e-9):float =
    var (l, r) = (s.a, s.b)
    if not f(r): return Inf
    while not valid_range(l, r, eps):
      let m = (l + r) * 0.5
      if f(m): r = m
      else: l = m
    return r
  proc findMax*(f:(float)->bool, s: Slice[float], eps = 1e-9):float =
    var (l, r) = (s.a, s.b)
    if not f(l): return -Inf
    while not valid_range(l, r, eps):
      let m = (l + r) * 0.5
      if f(m): l = m
      else: r = m
    return l

proc solve(N:int, x:seq[int], y:seq[int]) =
  var p = newSeq[Complex[float]]()
  for i in 0..<N:
    p.add complex(x[i].float, y[i].float)
  proc test(r:float):bool =
    var dsu = initDSU(N + 2)
    for i in 0..<N:
      if abs(-100.0 - p[i].im) <= r * 2: dsu.merge(i, N)
      if abs(100.0 - p[i].im) <= r * 2: dsu.merge(i, N + 1)
      for j in i+1..<N:
        if abs(p[i] - p[j]) <= r * 2: dsu.merge(i, j)
    return dsu.leader(N) != dsu.leader(N + 1)
  echo findMax(test, 0.0..100.0, 1e-6)
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
#}}}
