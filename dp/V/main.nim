#{{{ header
{.hints:off warnings:off optimization:speed.}
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
    let c = getchar()
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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

var N:int
var M:int
var x:seq[int]
var y:seq[int]

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  x = newSeqWith(N-1, 0)
  y = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt() - 1
    y[i] = nextInt() - 1
#}}}

#ReRooting: initReRooting[Weight, Data](n:int, f_up(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data)
# {{{
import sequtils, future
type
  Node[Weight] = object
    to, rev: int
    data: Weight
  ReRooting[Weight, Data] = object
    g:seq[seq[Node[Weight]]]
    ldp, rdp: seq[seq[Data]]
    lptr, rptr: seq[int]
    ident: Data
    f_up: (Data,Weight)->Data
    f_merge: (Data,Data)->Data

proc initNode[Weight](to, rev:int, d: Weight):Node[Weight] = Node[Weight](to: to, rev: rev, data: d)
proc initReRooting[Weight, Data](n:int, f_up:(Data,Weight)->Data, f_merge:(Data,Data)->Data, ident:Data):ReRooting[Weight,Data] =
  return ReRooting[Weight,Data](
    g:newSeqWith(n, newSeq[Node[Weight]]()),
    ldp:newSeqWith(n, newSeq[Data]()),
    rdp:newSeqWith(n, newSeq[Data]()),
    lptr:newSeq[int](n), rptr:newSeq[int](n),
    f_up:f_up, f_merge:f_merge, ident:ident)

proc addEdge[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, d))
proc addEdgeBi[Weight, Data](self: var ReRooting[Weight, Data]; u,v:int, d,e:Weight) =
  self.g[u].add(initNode[Weight](v, self.g[v].len, d))
  self.g[v].add(initNode[Weight](u, self.g[u].len - 1, e))
proc dfs[Weight, Data](self: var ReRooting[Weight, Data], idx, par:int):Data =
  while self.lptr[idx] != par and self.lptr[idx] < self.g[idx].len:
    var e = self.g[idx][self.lptr[idx]].addr
    self.ldp[idx][self.lptr[idx] + 1] = self.f_merge(self.ldp[idx][self.lptr[idx]], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.lptr[idx] += 1
  while self.rptr[idx] != par and self.rptr[idx] >= 0:
    var e = self.g[idx][self.rptr[idx]].addr
    self.rdp[idx][self.rptr[idx]] = self.f_merge(self.rdp[idx][self.rptr[idx] + 1], self.f_up(self.dfs(e[].to, e[].rev), e[].data))
    self.rptr[idx] -= 1
  if par < 0: return self.rdp[idx][0]
  return self.f_merge(self.ldp[idx][par], self.rdp[idx][par + 1])

proc solve[Weight, Data](self: var ReRooting[Weight, Data]):seq[Data] =
  for i in 0..<self.g.len:
    self.ldp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.rdp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.lptr[i] = 0
    self.rptr[i] = self.g[i].len - 1
  result = newSeq[Data]()
  for i in 0..<self.g.len: result.add(self.dfs(i, -1))
#}}}

block solve:
  g := initReRooting[int,int](N, (d:int, w:int)=>d + w, (a:int,b:int)=>(a*b) mod M, 1)
  for i in 0..<N-1:
    g.addEdgeBi(x[i], y[i], 1, 1)
  let ans = g.solve()
  for a in ans:
    echo a
