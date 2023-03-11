#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams, future
when defined(MYDEBUG):
  import header

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
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ Union-Find
type UnionFind = object
  data:seq[int]

proc newUnionFind(size:int):UnionFind =
  var uf:UnionFind
  uf.data = newSeqWith(size,-1)
  return uf
proc compress(uf:var UnionFind,x:int,r:var int):void =
  if uf.data[x]<0:
    r = x
    return
  uf.compress(uf.data[x],r)
  uf.data[x] = r;

proc root(uf:var UnionFind, x:int):int =
  var r:int
  uf.compress(x,r)
  return r;

proc size(uf:var UnionFind, x:int):int =
  return -uf.data[uf.root(x)]

proc unionSet(uf:var UnionFind, x,y:int):bool{.discardable.} =
  var
    rx = uf.root(x)
    ry = uf.root(y)
  if rx != ry:
    if uf.data[ry] < uf.data[rx]:
      swap(rx, ry)
    uf.data[rx] += uf.data[ry]
    uf.data[ry] = rx
  return rx != ry;

proc findSet(uf:var UnionFind, x,y:int):bool =
  return uf.root(x) == uf.root(y)

#}}}

let YES = "Yes"
let NO = "No"

proc solve(N:int, M:int, Q:int, A:seq[int], B:seq[int], C:seq[int]) =
  var uf_two = newUnionFind(N)
  for i in 0..<Q:
    if C[i] == 1: uf_two.unionSet(A[i],B[i])
  var uf_two_roots = initSet[int]()
  for u in 0..<N:
    uf_two_roots.incl(uf_two.root(u))
  var uf_one = uf_two
  var uf_one_matched = newSeqWith(N, false)
  for i in 0..<Q:
    if C[i] == 0:
      var ra = uf_two.root(A[i])
      var rb = uf_two.root(B[i])
      if ra == rb or uf_one.findSet(ra, rb):
        echo NO
        return
      uf_one.unionSet(ra,rb)
      uf_one_matched[uf_one.root(A[i])] = true
  var s = initTable[int,int]()
  var
    matched = newSeq[int]()
    unmatched = newSeq[int]()
  for u in 0..<N:
    var ru = uf.root(u)
    if ru notin s: s[ru] = 0
    s[ru] += 1
  for k, v in s.pairs:
    if is_unique[k]:
      matched.add(v)
    else:
      unmatched.add(v)
  matched.sort()
  unmatched.sort()


  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var Q = 0
  Q = nextInt()
  var A = newSeqWith(Q-1-0+1, 0)
  var B = newSeqWith(Q-1-0+1, 0)
  var C = newSeqWith(Q-1-0+1, 0)
  for i in 0..<Q-1-0+1:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, Q, A, B, C);
  return

main()
#}}}
