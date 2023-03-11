#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
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
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

proc sort[T](a:var seq[T]) = a.sort(cmp[T])

template `:=`(a, b: untyped): untyped =
  when declaredInScope a:
    a = b
  else:
    var a = b
  when not declared seiuchi:
    proc seiuchi(x: auto): auto {.discardable.} = x
  seiuchi(x = b)

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

proc solve(N:int, M:int, X:seq[int], A:seq[int], B:seq[int], Y:seq[int]) =
  S := X
  uf := newUnionFind(N)
  e := newSeq[(int,int,int)]()
  dp := newSeqWith(N,0)
  for i in 0..<M: e.add((Y[i], A[i], B[i]))
  e.sort()
  for ei in e:
    y := ei[0]
    a := ei[1]
    b := ei[2]
    if uf.findSet(a,b):
      r := uf.root(a)
      if S[r] >= y: dp[r] = 0
      else: dp[r] += 1
    else:
      ra := uf.root(a)
      rb := uf.root(b)
      s := S[ra] + S[rb]
      dpsum := dp[ra] + dp[rb]
      uf.unionSet(a, b)
      r := uf.root(a)
      S[r] = s
      if S[r] >= y: dp[r] = 0
      else: dp[r] = dpsum + 1
  r := uf.root(0)
  echo dp[r]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt(1)
    B[i] = nextInt(1)
    Y[i] = nextInt()
  solve(N, M, X, A, B, Y);
  return

main()
#}}}
