# verify-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind

when not declared ATCODER_HEADER_HPP:
  const ATCODER_HEADER_HPP* = 1
  {.hints:off checks:off assertions:on checks:off optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/streams as streams_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
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
when not declared ATCODER_DSU_HPP:
  const ATCODER_DSU_HPP* = 1

  import std/sequtils

  type
    DSU* = ref object
      n: int
      par_or_siz: seq[int]

  proc initDSU*(n: int): DSU {.inline.} =
    return DSU(n: n, par_or_siz: newSeqWith(n, -1))

  proc leader*(self: DSU; a: int): int {.inline.} =
    ## Path compression
    if self.par_or_siz[a] < 0: return a
    self.par_or_siz[a] = self.leader(self.par_or_siz[a])
    return self.par_or_siz[a]

  proc same*(self: DSU; a, b: int): bool {.inline.} =
    self.leader(a) == self.leader(b)

  proc size*(self: DSU; a: int): int {.inline.} =
    - self.par_or_siz[self.leader(a)]

  proc merge*(self: DSU; a, b: int): int {.inline, discardable.} =

    var
      x = self.leader(a)
      y = self.leader(b)

    if x == y: return x
    if self.par_or_siz[x] > self.par_or_siz[y]: swap(x, y)
    self.par_or_siz[x] += self.par_or_siz[y]
    self.par_or_siz[y] = x
    return x

  proc groups*(self: DSU): seq[seq[int]] {.inline.} =
    var
      leaderBuf = newSeq[int](self.n)
      groupsize = newSeq[int](self.n)
    for i in 0 ..< self.n:
      leaderBuf[i] = self.leader(i)
      groupsize[leaderBuf[i]].inc
    result = (0 ..< self.n).mapIt(newSeqOfCap[int](groupsize[it]))
    for i, ldr in leaderBuf:
      result[ldr].add i
    result.keepItIf(it.len > 0)

let N, Q = nextInt()

var uf = initDSU(N)

for _ in 0 ..< Q:
  let t, u, v = nextInt()

  if t == 0:
    uf.merge(u, v)
  elif t == 1:
    echo(
      if uf.same(u, v):
        1
      else:
        0
    )

