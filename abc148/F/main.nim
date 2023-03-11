#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}

#{{{ Graph
import sequtils

type
  Edge[T] = object
    src,dst:int
    weight:T
    rev:int
  Edges[T] = seq[Edge[T]]
  Graph[T] = seq[seq[Edge[T]]]

proc initEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

proc initGraph[T](n:int):Graph[T] =
  return newSeqWith(n,newSeq[Edge[T]]())

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(initEdge(src,dst,weight,g[dst].len))
  g[dst].add(initEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(initEdge(src,dst,weight,-1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

type DoublingLowestCommonAncestor[T] = object
  LOG:int
  dep:seq[int]
  table:seq[seq[int]]

proc initDoublingLowestCommonAncestor[T](g:Graph[T], r = 0):DoublingLowestCommonAncestor[T] =
  var
    LOG = 0
    t = 1
  while t <= g.len: t *= 2;LOG+=1
  var
    dep = newSeqWith(g.len,0)
    table = newSeqWith(LOG, newSeqWith(g.len, -1))

  proc dfs(idx, par, d:int) =
    table[0][idx] = par
    dep[idx] = d
    for e in g[idx]:
      if e.dst != par: dfs(e.dst, idx, d + 1)

  dfs(r, -1, 0)
  for k in 0..<LOG-1:
    for i in 0..<table[k].len:
      if table[k][i] == -1: table[k + 1][i] = -1
      else: table[k + 1][i] = table[k][table[k][i]]

  return DoublingLowestCommonAncestor[T](LOG:LOG, dep:dep, table:table)

proc query[T](self: DoublingLowestCommonAncestor[T], u,v:int):int =
  var (u,v) = (u,v)
  if self.dep[u] > self.dep[v]: swap(u,v)
  for i in countdown(self.LOG-1, 0):
    if (((self.dep[v] - self.dep[u]) shr i) and 1) > 0: v = self.table[i][v]
  if u == v: return u
  for i in countdown(self.LOG-1, 0):
    if self.table[i][u] != self.table[i][v]:
      u = self.table[i][u]
      v = self.table[i][v]
  return self.table[0][u]

proc solve(N:int, u:int, v:int, A:seq[int], B:seq[int]) =
  var g = initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(A[i], B[i])
  var lca = g.initDoublingLowestCommonAncestor(v)
  var ans = 0
  for w in 0..<N:
    t := lca.query(u,w)
    if lca.dep[t] * 2 > lca.dep[u]:
      ans.max=lca.dep[w]
  echo ans - 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var u = 0
  u = nextInt() - 1
  var v = 0
  v = nextInt() - 1
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, u, v, A, B);
  return

main()
#}}}
