# {{{ header
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm
  import std/sequtils
  import std/tables
  import std/macros
  import std/math as math_lib
  import std/sets
  import std/strutils
  import std/strformat
  import std/sugar
  
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
  discard

var N:int
var M:int
var S:seq[string]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  S = newSeqWith(N, nextString())
#}}}

when not declared ATCODER_MINCOSTFLOW_HPP:
  const ATCODER_MINCOSTFLOW_HPP* = 1

  import std/heapqueue
  import std/sequtils

  type edge*[Cap, Cost] = object
    dst, rev:int
    cap:Cap
    cost:Cost

  type mcf_graph*[Cap, Cost] = object
    n:int
    pos:seq[(int,int)]
    g:seq[seq[edge[Cap, Cost]]]

  type edge_info*[Cap, Cost] = object
    src, dst:int
    cap, flow: Cap
    cost: Cost

  proc initMCFGraph*[Cap, Cost](n:int):auto = mcf_graph[Cap, Cost](n:n, g:newSeq[seq[edge[Cap, Cost]]](n))

  proc add_edge*[Cap, Cost](self: var mcf_graph[Cap, Cost], src:int, dst:int, cap:Cap, cost:Cost):int {.discardable.} =
    assert src in 0..<self.n
    assert dst in 0..<self.n
    let m = self.pos.len
    self.pos.add((src, self.g[src].len))
    self.g[src].add(edge[Cap, Cost](dst:dst, rev:self.g[dst].len, cap:cap, cost:cost))
    self.g[dst].add(edge[Cap, Cost](dst:src, rev:self.g[src].len - 1, cap:Cap(0), cost: -cost))
    return m

  proc get_edge*[Cap, Cost](self: mcf_graph[Cap, Cost], i:int):edge_info[Cap, Cost] =
    let m = self.pos.len
    assert 0 <= i and i < m
    let e = self.g[self.pos[i][0]][self.pos[i][1]]
    let re = self.g[e.dst][e.rev]
    return edge_info[Cap, Cost](src:self.pos[i][0], dst:e.dst, cap:e.cap + re.cap, flow:re.cap, cost:e.cost)

  proc edges*[Cap, Cost](self: mcf_graph[Cap, Cost]):seq[edge_info[Cap, Cost]] =
    let m = self.pos.len
    result = newSeq[edge_info[Cap, Cost]](m)
    for i in 0..<m:
      result[i] = self.get_edge(i)

  proc slope*[Cap, Cost](self: var mcf_graph[Cap, Cost], s, t:int, flow_limit:Cap):seq[(Cap, Cost)] =
    assert s in 0..<self.n
    assert t in 0..<self.n
    assert s != t
    # variants (C = maxcost):
    # -(n-1)C <= dual[s] <= dual[i] <= dual[t] = 0
    # reduced cost (= e.cost + dual[e.src] - dual[e.to]) >= 0 for all edge
    var
      dual = newSeqWith(self.n, Cost(0))
      dist = newSeq[Cost](self.n)
      pv, pe = newSeq[int](self.n)
      vis = newSeq[bool](self.n)
    proc dual_ref(self:var mcf_graph[Cap, Cost]):bool =
      dist.fill(Cost.high)
      pv.fill(-1)
      pe.fill(-1)
      vis.fill(false)
      type Q = tuple[key:Cost, dst:int]
      proc `<`(l,r:Q):bool = l.key < r.key

      var que = initHeapQueue[Q]()
      dist[s] = 0
      que.push((Cost(0), s))
      while que.len > 0:
        let v = que.pop().dst
        if vis[v]: continue
        vis[v] = true
        if v == t: break
        # dist[v] = shortest(s, v) + dual[s] - dual[v]
        # dist[v] >= 0 (all reduced cost are positive)
        # dist[v] <= (n-1)C
        for i in 0..<self.g[v].len:
          let e = self.g[v][i]
          if vis[e.dst] or e.cap == 0: continue
          # |-dual[e.dst] + dual[v]| <= (n-1)C
          # cost <= C - -(n-1)C + 0 = nC
          let cost = e.cost - dual[e.dst] + dual[v]
          if dist[e.dst] - dist[v] > cost:
            dist[e.dst] = dist[v] + cost
            pv[e.dst] = v
            pe[e.dst] = i
            que.push((dist[e.dst], e.dst))
      if not vis[t]:
        return false

      for v in 0..<self.n:
        if not vis[v]: continue
        # dual[v] = dual[v] - dist[t] + dist[v]
        #     = dual[v] - (shortest(s, t) + dual[s] - dual[t]) + (shortest(s, v) + dual[s] - dual[v])
        #     = - shortest(s, t) + dual[t] + shortest(s, v)
        #     = shortest(s, v) - shortest(s, t) >= 0 - (n-1)C
        dual[v] -= dist[t] - dist[v]
      return true
    var
      flow = Cap(0)
      cost = Cost(0)
      prev_cost = -1
    result = newSeq[(Cap, Cost)]()
    result.add((flow, cost))
    while flow < flow_limit:
      if not self.dual_ref(): break
      var c = flow_limit - flow
      var v = t
      while v != s:
        c = min(c, self.g[pv[v]][pe[v]].cap)
        v = pv[v]
      v = t
      while v != s:
        var e = self.g[pv[v]][pe[v]].addr
        e[].cap -= c
        self.g[v][e[].rev].cap += c
        v = pv[v]
      let d = -dual[s]
      flow += c
      cost += c * d
      if prev_cost == d:
        discard result.pop()
      result.add((flow, cost))
      prev_cost = cost
  proc flow*[Cap, Cost](self: var mcf_graph[Cap, Cost], s,t:int):(Cap, Cost) =
    self.flow(s, t, Cap.high)
  proc flow*[Cap, Cost](self: var mcf_graph[Cap, Cost], s,t:int, flow_limit:Cap):(Cap, Cost) =
    self.slope(s, t, flow_limit)[^1]
  proc slope*[Cap, Cost](self: var mcf_graph[Cap, Cost], s,t:int):seq[(Cap, Cost)] =
    self.slope(s, t, Cap.high)
  discard

const dir = [[0, 1], [1, 0]]

proc id(i, j:int):int = i * M + j

proc main() =
  let BIG = 1000000000
  let
    s = N * M
    t = s + 1
  var mcf_graph = initMCFGraph[int,int](N * M + 2)
  var num = 0
  for s in S:
    num += s.count('o')
  mcf_graph.add_edge(s, t, num, BIG)
  for i in 0..<N:
    for j in 0..<M:
      for d in 0..<2:
        if S[i][j] == '#': continue
        let
          i2 = i + dir[d][0]
          j2 = j + dir[d][1]
        if i2 notin 0..<N or j2 notin 0..<M: continue
        if S[i2][j2] == '#': continue
        mcf_graph.add_edge(id(i, j), id(i2, j2), 100, 0)
  for i in 0..<N:
    for j in 0..<M:
      if S[i][j] == 'o':
        mcf_graph.add_edge(s, id(i, j), 1, i + j)
      if S[i][j] == '.':
        mcf_graph.add_edge(id(i, j), t, 1, BIG - (i + j))
  let r = mcf_graph.flow(s, t, num)
  echo BIG * num - r[1]
  return

main()

