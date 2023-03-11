import sequtils, sets
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

var adj:seq[seq[int]]

type LogUnionFind = object
  id:seq[int]
  di:seq[seq[int]]

proc newLogUnionFind(N:int):LogUnionFind =
  var
    id = newSeq[int](N)
    di = newSeqWith(N, newSeq[int]())
  for u in 0..<N:
    id[u] = u
    di[u].add(u)
  return LogUnionFind(id:id, di:di)

proc unionSet(self: var LogUnionFind, a, b:int):int =
  var
    a = a
    b = b
  a = self.id[a]
  b = self.id[b]
  if a == b: return
  if self.di[a].len + adj[a].len < self.di[b].len + adj[b].len: swap(a,b)
  for v in self.di[b]:
    self.id[v] = a
    self.di[a].add(v)
  for v in adj[b]:
    adj[a].add(v)
  return a

proc findSet(self: LogUnionFind, a, b:int):bool =
  return self.id[a] == self.id[b]

let YES = "Yes"
let NO = "No"

proc solve(N:int, Q:int, t:seq[int], u:seq[int], v:seq[int]):void =
  var uf = newLogUnionFind(N)
  var edges = initSet[(int,int)]()
  adj = newSeqWith(N, newseq[int]())
  proc complete(u, p:int):int =
    var r = uf.id[u]
    let a = adj[u]
    for v in a:
      if v == p: continue
      let rv = uf.id[v]
      r = uf.unionSet(r, rv)
    return r

  for i in 0..<Q:
    if t[i] == 1:
      if u[i] < v[i]: edges.incl((u[i],v[i]))
      else: edges.incl((v[i],u[i]))
      if not uf.findSet(u[i], v[i]):
        let
          ru = uf.id[u[i]]
          rv = uf.id[v[i]]
        adj[ru].add(rv)
        adj[rv].add(ru)
    elif t[i] == 2:
      discard complete(u[i], -1)
    else:
      if uf.findSet(u[i], v[i]) or (u[i], v[i]) in edges or (v[i], u[i]) in edges:
        echo YES
      else:
        echo NO
  
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var Q = 0
  Q = nextInt()
  var t = newSeqWith(Q, 0)
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, Q, t, u, v);
  return

main()
