#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
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

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

let dir4:array[4, tuple[x, y:int]] = [(0, 1), (1, 0), (0, -1), (-1, 0)]
let dir8:array[8, tuple[x, y:int]] = [(0, 1), (1, 0), (0, -1), (-1, 0), (1,1),(1,-1),(-1,1),(-1,-1)]

let N, M = nextInt()
let A = newSeqWith(N, nextString())

var sx, sy, gx, gy:int

for i in 0..<N:
  for j in 0..<M:
    if A[i][j] == 'S':
      sx = i;sy = j
    elif A[i][j] == 'G':
      gx = i;gy = j

let U = 9

import heapqueue

type S = object
  x, y, u: int
  d: int
 
proc `<`(a,b:S):auto = a.d < b.d

var
  dist = Seq(N, M, U + 1, int.inf)
  vis = Seq(N, M, U + 1, false)
  Q = initHeapQueue[S]()

# init
dist[sx][sy][0] = 0
Q.push(S(x:sx, y:sy, d:0))

while Q.len > 0:
  var e = Q.pop()
  let (x, y, u, d) = (e.x, e.y, e.u, e.d)
  if vis[x][y][u]: continue
  vis[x][y][u] = true
  for p in dir4:
    let (x2, y2) = (x + p.x, y + p.y)
    if x2 notin 0..<N or y2 notin 0..<M: continue
    var u2:int
    if A[x2][y2] == 'G':
      u2 = u
    else:
      let a = A[x2][y2].ord - '0'.ord
      if a == u + 1:
        u2 = u + 1
      else:
        u2 = u
    let d2 = d + 1
    if dist[x2][y2][u2] > d2:
      dist[x2][y2][u2] = d2
      Q.push(S(x:x2, y:y2, u:u2, d:d2))

if dist[gx][gy][9] == int.inf:
  print -1
else:
  print dist[gx][gy][9]
