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
when not declared ATCODER_EXTRA_DIJKSTRA_HPP:
  const ATCODER_EXTRA_DIJKSTRA_HPP* = 1
  import std/heapqueue
  import std/sequtils
  import std/algorithm
  import std/deques

  proc dijkstra01*[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
    var
      n = g.len
      dist = newSeqWith(n,T.inf)
      prev = newSeqWith(n,-1)
      Q = initDeque[Edge[T]]()
    dist[s] = T(0)
    Q.addFirst(initEdge[T](-2,s,T(0)))
    while Q.len > 0:
      var e = Q.popFirst()
      if prev[e.dst] != -1: continue
      prev[e.dst] = e.src;
      for f in g[e.dst]:
        var w = e.weight + f.weight;
        if dist[f.dst] > w:
          dist[f.dst] = w;
          if f.weight == 0:
            Q.addFirst(initEdge[T](f.src, f.dst, w))
          else:
            Q.addLast(initEdge[T](f.src, f.dst, w))
    return (dist,prev)

  proc dijkstra*[T](g:Graph[T], s:int): (seq[T],seq[int]) = 
    var
      n = g.len
      dist = newSeqWith(n,T.inf)
      prev = newSeqWith(n,-1)
      Q = initHeapQueue[Edge[T]]()
    dist[s] = T(0)
    Q.push(initEdge[T](-2,s,T(0)))
    while Q.len > 0:
      var e = Q.pop()
      if prev[e.dst] != -1: continue
      prev[e.dst] = e.src;
      for f in g[e.dst]:
        var w = e.weight + f.weight;
        if dist[f.dst] > w:
          dist[f.dst] = w;
          Q.push(initEdge[T](f.src, f.dst, w))
      discard
    return (dist,prev)
  
  proc path*(t: int, prev: seq[int]): seq[int] = 
    var u = t
    while u >= 0:
      result.add(u)
      u = prev[u]
    result.reverse()
# }}}


proc solve() =
  let H, W = nextInt()
  let a = newSeqWith(H, nextString())
  proc id(x, y:int):int =
    x * W + y
  proc id(c:char):int = H * W + c.ord - 'a'.ord
  var g = initGraph[int32](H * W + 26)
  var sid, gid:int
  for i in 0..<H:
    for j in 0..<W:
      if a[i][j] == '#': continue
      let t = id(i, j)
      if i + 1 < H and a[i + 1][j] != '#': g.addBiEdge(t, id(i + 1, j), 1)
      if j + 1 < W and a[i][j + 1] != '#': g.addBiEdge(t, id(i, j + 1), 1)
      if a[i][j].ord in 'a'.ord..'z'.ord:
        let u = id(a[i][j])
        g.addEdge(t, u, 0)
        g.addEdge(u, t, 1)
      if a[i][j] == 'S':sid = id(i, j)
      if a[i][j] == 'G':gid = id(i, j)
  var (dist, prev) = g.dijkstra01(sid)
  echo if dist[gid] == int32.inf: -1 else: dist[gid]
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
