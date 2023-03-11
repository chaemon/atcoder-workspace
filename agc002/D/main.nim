#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
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

const LOG = 3

# Persistent Array {{{
type
  Node[T] = ref object
    data:T
    child:array[1 shl LOG, Node[T]]
  PersistentArray[T] = object
    root: Node[T]

proc build[T](t:var Node[T], data:T, k:int):Node[T] =
  if t == nil: t = Node[T]()
  if k == 0:
    t.data = data
    return t
  let p = build(t.child[k and ((1 shl LOG) - 1)], data, k shr LOG)
  t.child[k and ((1 shl LOG) - 1)] = p
  return t

proc build[T](self:var PersistentArray[T], v:seq[T]) =
  self.root = nil
  for i in 0..<v.len:
    self.root = self.root.build(v[i], i)

proc initPersistentArray[T](v:seq[T]):auto =
  result = PersistentArray[T]()
  result.build(v)

proc `[]`[T](t:Node[T], k:int):auto =
  if k == 0: return t.data
  return t.child[k and ((1 shl LOG) - 1)][k shr LOG]

proc `[]`[T](self:PersistentArray[T], k:int):auto = return self.root[k]

proc `[]=`[T](t:var Node[T], k:int, val:T):Node[T] {.discardable.}=
  t = if t != nil: Node[T](data:t.data, child:t.child) else: Node[T]()
  if k == 0:
    t.data = val
    return t
  var p = (t.child[k and ((1 shl LOG) - 1)][k shr LOG] = val)
  t.child[k and ((1 shl LOG) - 1)] = p
  return t

proc `[]=`[T](self:var PersistentArray[T], k:int, val:T) =
  var ret = (self.root[k] = val)
  self.root = ret
# }}}

# PersistentUnionFind {{{
type PersistentUnionFind = object
  data: PersistentArray[int]

proc initPersistentUnionFind(sz:int):PersistentUnionFind =
  PersistentUnionFind(data:initPersistentArray[int](newSeqWith(sz, -1)))

proc find(self:PersistentUnionFind, k:int):int =
  let p = self.data[k]
  return if p >= 0: self.find(p) else: k

proc size(self:PersistentUnionFind, k:int):int = -self.data[self.find(k)]

proc union(self:PersistentUnionFind, x, y:int):PersistentUnionFind =
  let
    x = self.find(x)
    y = self.find(y)
  if x == y: return self
  var self = self
  let
    u = self.data[x]
    v = self.data[y]
  if u < v:
    self.data[x] = u + v
    self.data[y] = x
  else:
    self.data[y] = u + v
    self.data[x] = y
  return self
# }}}

# PartiallyPersistentUnionFind {{{
import sequtils, math, algorithm

type PartiallyPersistentUnionFind = object
  data, last: seq[int]
  add: seq[seq[(int,int)]]

proc initPartiallyPersistentUnionFind(sz:int):auto =
  return PartiallyPersistentUnionFind(
    data:newSeqWith(sz, -1), 
    last:newSeqWith(sz, 10^9), 
    add:newSeqWith(sz, @[(-1, -1)])
  )

proc find(self: PartiallyPersistentUnionFind, t, x:int):int =
  if t < self.last[x]: return x
  return self.find(t, self.data[x])

proc union(self: var PartiallyPersistentUnionFind, t, x, y:int):bool {.discardable.} =
  var
    x = self.find(t, x)
    y = self.find(t, y)
  if x == y: return false
  if self.data[x] > self.data[y]: swap(x, y)
  self.data[x] += self.data[y]
  self.add[x].add((t, self.data[x]))
  self.data[y] = x
  self.last[y] = t
  return true

proc size(self: PartiallyPersistentUnionFind, t, x:int):int =
  let x = self.find(t, x)
  let i = self.add[x].lower_bound((t, 0))
  return -self.add[x][i - 1][1]
# }}}

import sugar

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a - 1, s.b)
  if not f(r): return s.b + 1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  if not f(l): return s.a - 1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}

var
  N, M:int
  a, b:seq[int]
  Q:int
  x, y, z:seq[int]

proc solve() =
  var ufs = newSeq[PersistentUnionFind]()
  ufs.add(initPersistentUnionFind(N))
  for i in 0..<M:
    ufs.add(ufs[^1].union(a[i], b[i]))
  proc calc(x, y, z:int):int =
    proc f(t:int):bool =
      if ufs[t].find(x) == ufs[t].find(y):
        return ufs[t].size(x) >= z
      else:
        return ufs[t].size(x) + ufs[t].size(y) >= z
    return f.findFirst(1..M)
  for i in 0..<Q: echo calc(x[i], y[i], z[i])
  return
#proc solve() =
#  var uf = initPartiallyPersistentUnionFind(N)
#  for i in 0..<M:
#    uf.union(i + 1, a[i], b[i])
#  proc calc(x, y, z:int):int =
#    proc f(t:int):bool =
#      if uf.find(t, x) == uf.find(t, y):
#        return uf.size(t, x) >= z
#      else:
#        return uf.size(t, x) + uf.size(t, y) >= z
#    return f.findFirst(1..M)
#  for i in 0..<Q: echo calc(x[i], y[i], z[i])
#  return


#{{{ main function
proc main() =
  N = nextInt()
  M = nextInt()
  a = newSeqWith(M, 0)
  b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  Q = nextInt()
  x = newSeqWith(Q, 0)
  y = newSeqWith(Q, 0)
  z = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt() - 1
    y[i] = nextInt() - 1
    z[i] = nextInt()
  solve()
  return

main()
#}}}
