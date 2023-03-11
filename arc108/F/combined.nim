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

#import atcoder/modint
when not declared ATCODER_MONTGOMERY_MODINT_HPP:
  const ATCODER_MONTGOMERY_MODINT_HPP* = 1

  import std/macros
  when not declared ATCODER_GENERATE_DEFINITIONS_NIM:
    const ATCODER_GENERATE_DEFINITIONS_NIM* = 1
    import std/strformat
    import std/macros
  
    template generateDefinitions*(name, l, r, typeObj, typeBase, body: untyped): untyped {.dirty.} =
      proc name*(l, r: typeObj): auto {.inline.} =
        type T = l.type
        body
      proc name*(l: typeBase; r: typeObj): auto {.inline.} =
        type T = r.type
        body
      proc name*(l: typeObj; r: typeBase): auto {.inline.} =
        type T = l.type
        body
  
    template generatePow*(name) {.dirty.} =
      proc pow*(m: name; p: SomeInteger): name {.inline.} =
        assert (p.type)(0) <= p
        var
          p = p.uint
          m = m
        result = m.unit()
        while p > 0'u:
          if (p and 1'u) != 0'u: result *= m
          m *= m
          p = p shr 1'u
      proc `^`*[T:name](m: T; p: SomeInteger): T {.inline.} = m.pow(p)
  
    macro generateConverter*(name, from_type, to_type) =
      parseStmt(fmt"""type {name.repr}* = {to_type.repr}{'\n'}converter to{name.repr}OfGenerateConverter*(a:{from_type}):{name.repr} {{.used.}} = {name.repr}.init(a){'\n'}""")
    discard

  type StaticLazyMontgomeryModInt*[M:static[uint32]] = object
    a:uint32
  type DynamicLazyMontgomeryModInt*[T:static[int]] = object
    a:uint32
  type LazyMontgomeryModInt = StaticLazyMontgomeryModInt or DynamicLazyMontgomeryModInt

  proc get_r*(M:uint32):auto =
    result = M
    for i in 0..<4: result *= 2.uint32 - M * result
  proc get_n2*(M:uint32):auto = (((not M.uint) + 1.uint) mod M.uint).uint32

  proc getMontgomeryParameters(M:uint32):tuple[M, r, n2:uint32] =
    (M, get_r(M), get_n2(M))

  proc getParameters*[T:static[int]](t:typedesc[DynamicLazyMontgomeryModInt[T]]):ptr[tuple[M, r, n2:uint32]] =
    var p {.global.} : tuple[M, r, n2:uint32] = getMontgomeryParameters(998244353.uint32)
    return p.addr

  proc checkParameters(M, r:uint32) =
    assert r * M == 1, "invalid, r * mod != 1"
    assert M < (1 shl 30), "invalid, mod >= 2 ^ 30"
    assert (M and 1) == 1, "invalid, mod % 2 == 0"

  proc setMod*[T:static[int]](self:typedesc[DynamicLazyMontgomeryModInt[T]], M:SomeInteger) =
    let p = getMontgomeryParameters(M.uint32)
    checkParameters(p.M, p.r)
    (self.getParameters)[] = p

  template getMod*[T:StaticLazyMontgomeryModInt](self:T or typedesc[T]):uint32 = T.M.uint32
  template getMod*[T:static[int]](self:typedesc[DynamicLazyMontgomeryModInt[T]] or DynamicLazyMontgomeryModInt[T]):uint32 =
    (DynamicLazyMontgomeryModInt[T].getParameters)[].M.uint32
  template `mod`*[T:LazyMontgomeryModInt](self:T or typedesc[T]):int = T.get_mod.int

  template reduce(T:typedesc[LazyMontgomeryModInt], b:uint):uint32 =
    when T is StaticLazyMontgomeryModInt:
      const M = T.get_mod
      const r = get_r(M)
      static:
        checkParameters(M, r)
      ((b + (cast[uint32](b) * ((not r) + 1.uint32)).uint * M.uint) shr 32).uint32
    elif T is DynamicLazyMontgomeryModInt:
      let p = (T.getParameters)[]
      ((b + (cast[uint32](b) * ((not p.r) + 1.uint32)).uint * p.M.uint) shr 32).uint32
    else:
      assert false, "no such lazy montgomerymodint"

  proc init*[T:LazyMontgomeryModInt](t:typedesc[T], b:T or SomeInteger):auto {.inline.} =
    when b is LazyMontgomeryModInt: return b
    else:
      when b is SomeUnsignedInt:
        let b = (b.uint mod T.get_mod.uint).int
      when T is StaticLazyMontgomeryModInt:
        const n2 = get_n2(T.get_mod)
        return T(a:T.reduce((b.int mod T.get_mod.int + T.get_mod.int).uint * n2))
      elif T is DynamicLazyMontgomeryModInt:
        let p = (T.getParameters)[]
        return T(a:T.reduce((b.int mod p.M.int + p.M.int).uint * p.n2))
  proc unit*[T:LazyMontgomeryModInt](t:typedesc[T] or T):T = T.init(1)

  proc val*[T:LazyMontgomeryModInt](self: T):int =
    var a = T.reduce(self.a.uint)
    if a >= T.get_mod: a -= T.get_mod
    return a.int

  proc `+=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a += b.a - 2.uint32 * T.get_mod
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.get_mod
    return self

  proc `-=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a -= b.a
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.get_mod
    return self

  proc inc*[T:LazyMontgomeryModInt](self: var T):T {.discardable, inline.} =
    return self += 1
  proc dec*[T:LazyMontgomeryModInt](self: var T):T {.discardable, inline.} =
    return self -= 1

  proc `*=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a = T.reduce(self.a.uint * b.a.uint)
    return self

  generatePow(LazyMontgomeryModInt)

  proc inv*[T:LazyMontgomeryModInt](self: T):T = self.pow(T.mod - 2)

  proc `/=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self *= b.inv()
    return self

  generateDefinitions(`+`, m, n, LazyMontgomeryModInt, SomeInteger):
    result = T.init(m)
    result += T.init(n)

  generateDefinitions(`-`, m, n, LazyMontgomeryModInt, SomeInteger):
    result = T.init(m)
    result -= T.init(n)

  generateDefinitions(`*`, m, n, LazyMontgomeryModInt, SomeInteger):
    result = T.init(m)
    result *= T.init(n)

  generateDefinitions(`/`, m, n, LazyMontgomeryModInt, SomeInteger):
    result = T.init(m)
    result /= T.init(n)

  generateDefinitions(`==`, m, n, LazyMontgomeryModInt, SomeInteger):
    result = (T.init(m).val() == T.init(n).val())

  proc `$`*(m: LazyMontgomeryModInt): string {.inline.} = $(m.val())
  proc `-`*[T:LazyMontgomeryModInt](self:T):T = T.init(0) - self

  template useStaticMontgomery*(name, M) =
    generateConverter(name, int, StaticLazyMontgomeryModInt[M])
  template useDynamicMontgomery*(name, M) =
    generateConverter(name, int, DynamicLazyMontgomeryModInt[M])

  useStaticMontgomery(modint998244353, 998244353)
  useStaticMontgomery(modint1000000007, 1000000007)
  useDynamicMontgomery(modint, -1)
const MOD = 1000000007
type mint = modint1000000007

when not declared ATCODER_GRAPH_TEMPLATE_HPP:
  const ATCODER_GRAPH_TEMPLATE_HPP* = 1
  import std/sequtils
  
  type
    Edge*[T] = object
      src*,dst*:int
      weight*:T
      rev*:int
    Edges*[T] = seq[Edge[T]]
    Graph*[T] = seq[seq[Edge[T]]]
    Matrix*[T] = seq[seq[T]]
  
  proc initEdge*[T](src,dst:int,weight:T = 1,rev:int = -1):Edge[T] =
    var e:Edge[T]
    e.src = src
    e.dst = dst
    e.weight = weight
    e.rev = rev
    return e
  
  proc initGraph*[T](n:int):Graph[T] =
    return newSeqWith(n,newSeq[Edge[T]]())
  
  proc addBiEdge*[T](g:var Graph[T],e:Edge[T]):void =
    var e_rev = e
    swap(e_rev.src, e_rev.dst)
    let (r, s) = (g[e.src].len, g[e.dst].len)
    g[e.src].add(e)
    g[e.dst].add(e_rev)
    g[e.src][^1].rev = s
    g[e.dst][^1].rev = r
  proc addBiEdge*[T](g:var Graph[T],src,dst:int,weight:T = 1):void =
    g.addBiEdge(initEdge(src, dst, weight))
  
  proc initUndirectedGraph*[T](n:int, a,b,c:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
  proc initUndirectedGraph*[T](n:int, a,b:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addBiEdge(a[i], b[i])
  proc initGraph*[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
  proc initGraph*[T](n:int, a,b:seq[int]):Graph[T] =
    result = initGraph[T](n)
    for i in 0..<a.len: result.addEdge(a[i], b[i])

  proc addEdge*[T](g:var Graph[T],e:Edge[T]):void =
    g[e.src].add(e)
  proc addEdge*[T](g:var Graph[T],src,dst:int,weight:T = T(1)):void =
    g.addEdge(initEdge(src, dst, weight, -1))
  
  proc `<`*[T](l,r:Edge[T]):bool = l.weight < r.weight
when not declared ATCODER_TREE_DIAMETER_HPP:
  const ATCODER_TREE_DIAMETER_HPP* = 1
  import std/sequtils
  proc treeDiameter*[T](g:Graph[T]):(T, seq[int]) =
    var next = newSeq[int](g.len)
    proc dfs(idx, par:int):(T, int) =
      result[1] = idx
      for i,e in g[idx]:
        if e.dst == par: continue
        var cost = dfs(e.dst, idx)
        cost[0] += e.weight
        if result[0] < cost[0]:
          next[idx] = i
          result = cost
    let p = dfs(0, -1)
    next = newSeqWith(g.len, -1)
    let q = dfs(p[1], -1)
    var
      ans = newSeq[int]()
      u = p[1]
    while true:
      ans.add(u)
      let idx = next[u]
      if idx == -1:break
      u = g[u][idx].dst
    return (q[0], ans)

proc solve(N:int, a:seq[int], b:seq[int]) =
  var g = initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(a[i], b[i])
  let (dist_max, v) = g.treeDiameter()
  let (p, q) = (v[0], v[^1])
  proc dfs(u, p, d:int, dist:var seq[int]) =
    dist[u] = d
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u, d + 1, dist)
  var dist_p, dist_q = newSeq[int](N)
  dfs(p, -1, 0, dist_p)
  dfs(q, -1, 0, dist_q)
  var dist_min = -int.inf
  var w = newSeq[int]()
  for u in 0..<N:
    dist_min >?= min(dist_p[u], dist_q[u])
    w.add max(dist_p[u], dist_q[u])
  w.sort()
  w.reverse()
  var
    wi = 0
    t = N
    a = newSeq[mint]()
  for d in dist_min..dist_max << 1:
    a.add(mint(2)^t)
    if d < dist_max: a[^1] *= 2
    while wi < N and w[wi] >= d: t.dec;wi.inc
  a.add(0)
  var
    ans = mint(0)
    ai = 0
  for d in dist_min..dist_max << 1:
    ans += (a[ai] - a[ai + 1]) * d
    ai.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
#}}}
