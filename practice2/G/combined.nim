# verify-helper: PROBLEM https://judge.yosupo.jp/problem/scc

when not declared ATCODER_HEADER_HPP:
  {.hints:off checks:off assertions:on checks:off optimization:speed .}
  const ATCODER_HEADER_HPP = 1
  import algorithm
  import sequtils
  import tables
  import macros
  import math
  import sets
  import strutils
  import streams
  import strformat
  import sugar
  
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  proc getchar*(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(base:int = 0): int =
    scanf("%lld",addr result)
    result -= base
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*(): string =
    var get = false;result = ""
    while true:
      var c = getchar()
      if int(c) > int(' '): get = true;result.add(c)
      elif get: break
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  discard
when not declared ATCODER_SCC_HPP:
  const ATCODER_SCC_HPP* = 1

  import sequtils
  when not declared ATCODER_INTERNAL_SCC_HPP:
    const ATCODER_INTERNAL_SCC_HPP* = 1
    
    import sequtils
    
    type csr[E] = object
      start:seq[int]
      elist:seq[E]
    proc initCsr[E](n:int, edges:seq[(int,E)]):auto =
      var
        start = newSeq[int](n + 1)
        elist = newSeq[E](edges.len)
      for e in edges:
        start[e[0] + 1].inc
      for i in 1..n:
        start[i] += start[i - 1]
      var counter = start
      for e in edges:
        elist[counter[e[0]]] = e[1]
        counter[e[0]].inc
      return csr[E](start:start, elist:elist)
    
    type edge = object
      dst:int
    # Reference:
    # R. Tarjan,
    # Depth-First Search and Linear Graph Algorithms
    type internal_scc_graph* = object
      n:int
      edges:seq[(int,edge)]
  
    proc init_internal_scc_graph*(n:int):auto = internal_scc_graph(n:n, edges:newSeq[(int,edge)]())
    
    proc num_vertices*(self: internal_scc_graph):int =  self.n
  
    proc add_edge*(self: var internal_scc_graph, src, dst:int) = self.edges.add((src, edge(dst:dst)))
  
    # @return pair of (# of scc, scc id)
    proc scc_ids*(self: internal_scc_graph):(int,seq[int]) =
      var g = initCsr[edge](self.n, self.edges)
      var now_ord, group_num = 0
      var
        visited = newSeqOfCap[int](self.n)
        low = newSeq[int](self.n)
        ord = newSeqWith(self.n, -1)
        ids = newSeq[int](self.n)
      proc dfs(v:int) =
        low[v] = now_ord
        ord[v] = now_ord
        now_ord.inc
        visited.add(v)
        for i in g.start[v] ..< g.start[v + 1]:
          let dst = g.elist[i].dst
          if ord[dst] == -1:
            dfs(dst)
            low[v] = min(low[v], low[dst])
          else:
            low[v] = min(low[v], ord[dst])
        if low[v] == ord[v]:
          while true:
            let u = visited[^1]
            discard visited.pop()
            ord[u] = self.n
            ids[u] = group_num
            if u == v: break
          group_num.inc
      for i in 0..<self.n:
        if ord[i] == -1: dfs(i)
      ids.applyIt(group_num - 1 - it)
      return (group_num, ids)
  
    proc scc*(self: internal_scc_graph):auto =
      let
        ids = self.scc_ids()
        group_num = ids[0]
      var counts = newSeq[int](group_num)
      for x in ids[1]: counts[x].inc
      result = newSeq[seq[int]](ids[0])
      for i in 0..<group_num:
        result[i] = newSeqOfCap[int](counts[i])
      for i in 0..<self.n:
        result[ids[1][i]].add(i)
    discard

  type scc_graph = object
    internal: internal_scc_graph

  proc initSccGraph(n:int):auto = init_internal_scc_graph(n)
  
  proc add_edge(self:var scc_graph, src, dst:int) =
    let n = self.internal.num_vertices()
    assert 0 <= src and dst < n
    assert 0 <= dst and dst < n
    self.internal.add_edge(src, dst)

  proc scc(self:scc_graph):auto = self.internal.scc()
  discard

block:
  let N, M = nextInt()
  var
    scc = initSccGraph(N)
  for i in 0..<M:
    let a, b = nextInt()
    scc.add_edge(a, b)
  var a = scc.scc()
  echo a.len
  for a in a:
    echo a.len, " ", a.join(" ")
