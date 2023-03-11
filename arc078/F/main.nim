#{{{ header
import algorithm, sequtils, tables, macros, math, sets, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (b shr n) mod 2
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (1 shl (s.b - s.a + 1))
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
proc countTrailingZeroBits(n:int):int =
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: return i
  assert(false)
proc popcount(n:int):int =
  result = 0
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: result += 1
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if s[i] == 0:
        found = true
        s[i] = 1
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

# Graph {{{
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

proc addBiEdge[T](g:var Graph[T],e:Edge[T]):void =
  var e_rev = e
  swap(e_rev.src, e_rev.dst)
  let (r, s) = (g[e.src].len, g[e.dst].len)
  g[e.src].add(e)
  g[e.dst].add(e_rev)
  g[e.src][^1].rev = s
  g[e.dst][^1].rev = r
proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addBiEdge(initEdge(src, dst, weight))

proc initUndirectedGraph[T](n:int, a,b: seq[int],c:seq[T]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])
proc initUndirectedGraph[T](n:int, a,b:seq[int]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addBiEdge(a[i], b[i], T(1))
proc initGraph[T](n:int, a,b:seq[int],c:seq[T]):Graph[T] =
  var result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])
proc initGraph[T](n:int, a,b:seq[int]):Graph[T] =
  result = initGraph[T](n)
  for i in 0..<a.len: result.addEdge(a[i], b[i], T(1))


proc addEdge[T](g:var Graph[T],e:Edge[T]):void =
  g[e.src].add(e)
proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g.addEdge(initEdge(src, dst, weight, -1))

proc `<`[T](l,r:Edge[T]):bool = l.weight < r.weight
#}}}

var cost: array[2^15, int]
var dp: array[2^15, array[15, int]]

proc solve(N:int, M:int, a:seq[int], b:seq[int], c:seq[int]) =
  for b in 0..<dp.len:
    for u in 0..<dp[0].len:
      dp[b][u] = int.inf
  var g = initUndirectedGraph(N, a, b, c)
  for b in 0..<2^N:
    var s = 0
    for u in 0..<N:
      if b[u] == 1:
        for e in g[u]:
          if b[e.dst] == 0:
            s += e.weight
    cost[b] = s
  for b in 0..<2^N:
    if b[0] == 0: continue
    dp[b][0] = cost[b]
  for b in 0..<2^N:
    let b_comp = ((not b) and ((1 shl N) - 1))
    for u in 0..<N:
      if dp[b][u] == int.inf: continue
      if b[u] == 0: continue
      for e in g[u]:
        let v = e.dst
        if b[v] == 1: continue
        doAssert b_comp[v] == 1
        for b2 in (b_comp xor (1 shl v)).subsets:
          let bb = b2 or (1 shl v)
          dp[b or bb][v].min=dp[b][u] + cost[bb] - e.weight * 2
  echo dp[(1 shl N) - 1][N - 1] div 2
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    c[i] = nextInt()
  solve(N, M, a, b, c)
  return

main()
#}}}
