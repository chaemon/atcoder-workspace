#{{{ header
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
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ ReRooting
import sequtils, future
type
  Node[Data] = object
    to, rev: int
    data: Data
  ReRooting[Data, T] = object
    g:seq[seq[Node[Data]]]
    ldp, rdp: seq[seq[T]]
    lptr, rptr: seq[int]
    ident: T
    f_up: (T,Data)->T
    f_merge: (T,T)->T

proc initNode[Data](to, rev:int, d: Data):Node[Data] = Node[Data](to: to, rev: rev, data: d)
proc initReRooting[Data, T](n:int, f_up:(T,Data)->T, f_merge:(T,T)->T, ident:T):ReRooting[Data,T] =
  return ReRooting[Data,T](
    g:newSeqWith(n, newSeq[Node[Data]]()),
    ldp:newSeqWith(n, newSeq[T]()),
    rdp:newSeqWith(n, newSeq[T]()),
    lptr:newSeq[int](n), rptr:newSeq[int](n),
    f_up:f_up, f_merge:f_merge, ident:ident)

proc addEdge[Data, T](self: var ReRooting[Data, T]; u,v:int, d:Data) =
  self.g[u].add(initNode[Data](v, self.g[v].len, d))
  self.g[v].add(initNode[Data](u, self.g[u].len - 1, d))
proc addEdgeBi[Data, T](self: var ReRooting[Data, T]; u,v:int, d,e:Data) =
  self.g[u].add(initNode[Data](v, self.g[v].len, d))
  self.g[v].add(initNode[Data](u, self.g[u].len - 1, e))
proc dfs[Data, T](self: var ReRooting[Data, T], idx, par:int):T =
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

proc solve[Data, T](self: var ReRooting[Data, T]):seq[T] =
  for i in 0..<self.g.len:
    self.ldp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.rdp[i] = newSeqWith(self.g[i].len + 1, self.ident)
    self.lptr[i] = 0
    self.rptr[i] = self.g[i].len - 1
  result = newSeq[T]()
  for i in 0..<self.g.len: result.add(self.dfs(i, -1))
#}}}

proc main():void =
  proc f_up(a:(float,int), data: int):(float, int) =
    result = ((if a[1] == 0: 0.0 else: a[0] / float(a[1])) + 1.0, 1)
  proc f_merge(a,b:(float,int)):(float, int) =
    result = (a[0] + b[0], a[1] + b[1])
  let N = nextInt()
  var g = initReRooting[int, (float, int)](N, f_up, f_merge, (0.0, 0))
  for i in 0..<N-1:
    let u, v = nextInt() - 1
    g.addEdge(u, v, 0)
  let dp = g.solve()
  for p in dp:
    echo if p[1] == 0: 0.0 else: p[0]/float(p[1])
  discard

main()

