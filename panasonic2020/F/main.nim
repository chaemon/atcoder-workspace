#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

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

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)

#}}}

var Q:int
var a:seq[int]
var b:seq[int]
var c:seq[int]
var d:seq[int]

#{{{ input part
proc main()
block:
  Q = nextInt()
  a = newSeqWith(Q, 0)
  b = newSeqWith(Q, 0)
  c = newSeqWith(Q, 0)
  d = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
    c[i] = nextInt() - 1
    d[i] = nextInt() - 1
#}}}

proc dist(s,t:tuple[x,y:int]):int = abs(s.x - t.x) + abs(s.y - t.y)

proc far(s,t:tuple[x,y:int], h:int):int =
  if h == 0:
    return 1
  let
    d = 3^(h - 1)
    p = (x:s.x div d, y:s.y div d)
    q = (x:t.x div d, y:t.y div d)
    s1 = (x:s.x mod d, y:s.y mod d)
    t1 = (x:t.x mod d, y:t.y mod d)
  if p.x != q.x:
    return dist(s, (t.x, t.y + 3^h))
  elif p.x == 1:
    result = int.inf
    block:
      let
        a = (d - 1, 3 * d - 1)
        b = (d - 1, 0)
      result.min=dist(s, a) + 1 + dist(b, t)
    block:
      let
        a = (2 * d, 3 * d - 1)
        b = (2 * d, 0)
      result.min=dist(s, a) + 1 + dist(b, t)
    return
  else:
    return far(s1, t1, h - 1) + (q.y + 3 - p.y - 1) * d


proc adj(s,t:tuple[x,y:int], h):int =
  if h == 0:
    return 1
  let
    d = 3^(h - 1)
    p = (x:s.x div d, y:s.y div d)
    q = (x:t.x div d, y:t.y div d)
    s1 = (x:s.x mod d, y:s.y mod d)
    t1 = (x:t.x mod d, y:t.y mod d)
  if p.x == q.x and p.y == 2 and q.y == 0:
    return adj(s1, t1, h - 1)
  else:
    return far(s, t, h)
  return

proc solve(s, t:tuple[x,y:int], h = 30):int =
  if h == 0:
    assert(s == t)
    return 0
  let
    d = 3^(h - 1)
    p = (x:s.x div d, y:s.y div d)
    q = (x:t.x div d, y:t.y div d)
    s1 = (x:s.x mod d, y:s.y mod d)
    t1 = (x:t.x mod d, y:t.y mod d)
#  echo "solve: ", s, " ", t, " ", h
#  echo p, q, s1, t1
  if p.x != q.x and p.y != q.y: return dist(s, t)
  if p.x == q.x and p.y == q.y: return solve(s1, t1, h - 1)
  if p.y == q.y: return solve((s.y, s.x), (t.y, t.x), h)
  # p.x == q.x
  if p.y > q.y: return solve(t, s, h)
  # p.y < q.y
  if p.x == 1 and q.x == 1:
    result = int.inf
    block:
      let
        a = (d - 1, d - 1)
        b = (d - 1, 2 * d)
      result.min=dist(s, a) + dist(a, b) + dist(b, t)
    block:
      let
        a = (2 * d, d - 1)
        b = (2 * d, 2 * d)
      result.min=dist(s, a) + dist(a, b) + dist(b, t)
    return
  if abs(q.y - p.y) > 1:
    return far(s1, t1, h - 1) + d
  else:
    return adj(s1, t1, h - 1)

let s = @[
  "...........................",
  ".#..#..#..#..#..#..#..#..#.",
  "...........................",
  "...###......###......###...",
  ".#.###.#..#.###.#..#.###.#.",
  "...###......###......###...",
  "...........................",
  ".#..#..#..#..#..#..#..#..#.",
  "...........................",
  ".........#########.........",
  ".#..#..#.#########.#..#..#.",
  ".........#########.........",
  "...###...#########...###...",
  ".#.###.#.#########.#.###.#.",
  "...###...#########...###...",
  ".........#########.........",
  ".#..#..#.#########.#..#..#.",
  ".........#########.........",
  "...........................",
  ".#..#..#..#..#..#..#..#..#.",
  "...........................",
  "...###......###......###...",
  ".#.###.#..#.###.#..#.###.#.",
  "...###......###......###...",
  "...........................",
  ".#..#..#..#..#..#..#..#..#.",
  "..........................."]



proc warshallFloyd(dist: seq[seq[int]]): seq[seq[int]] =
  let N = dist.len
  var dist = dist
  for k in 0..<N:
    for i in 0..<N:
      for j in 0..<N:
        if dist[i][k] == int.inf or dist[k][j] == int.inf: continue
        let d = dist[i][k] + dist[k][j]
        if dist[i][j] > d: dist[i][j] = d
  return dist

proc test() =
  let
    N = s.len
    M = s[0].len
  proc id(x, y):int = x * M + y
  dist := ndSeq(N*M, N*M, int.inf)
  for x in 0..<N:
    for y in 0..<M:
      if s[x][y] == '#': continue
      for x0 in 0..<N:
        for y0 in 0..<M:
          if s[x0][y0] == '#': continue
          if dist((x,y), (x0,y0)) == 1:
            dist[id(x, y)][id(x0, y0)] = 1
  dist = dist.warshallFloyd()
  for x in 0..<N:
    for y in 0..<N:
      if s[x][y] == '#': continue
      for x0 in 0..<N:
        for y0 in 0..<M:
          if s[x0][y0] == '#': continue
          if x == x0 and y == y0: continue
          let d = dist[id(x, y)][id(x0, y0)]
          let d2 = solve((x, y), (x0, y0))
          echo x, " ", y, " ", x0, " ", y0
          echo d, " ", d2
          doassert(d == d2)
  discard

proc main() =
#  echo solve((1, 8), (1, 9))
#  test()
  for i in 0..<Q:
    print solve((a[i], b[i]), (c[i], d[i]))
  return

main()
