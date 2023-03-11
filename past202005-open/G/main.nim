#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
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

type
  Concept_newSeqWith = concept x
    newSeqWith(0, x)

template SeqImpl(lens: seq[int]; init: typedesc or Concept_newSeqWith; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init: typedesc or Concept_newSeqWith): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: static varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template Array(lens: static varargs[int]; init: typedesc): auto =
  ArrayImpl(@lens, init, 1, lens.len).default
#}}}

var N:int
var X:int
var Y:int
var x:seq[int]
var y:seq[int]

#{{{ input part
block:
  N = nextInt()
  X = nextInt()
  Y = nextInt()
  x = newSeqWith(N, 0)
  y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
#}}}

let dir = [[1, 1], [0, 1], [-1, 1], [1, 0], [-1, 0], [0, -1]]

const D = 800

import heapqueue

type S = object
  x, y: int
  d: int
 
proc `<`(a,b:S):auto = a.d < b.d

var
  dist:array[-D..D, array[-D..D, int]]
  vis:array[-D..D, array[-D..D, bool]]
  a:array[-D..D, array[-D..D, bool]]
  valid = false
for i in -D..D:
  for j in -D..D:
    dist[i][j] = int.inf
    vis[i][j] = false
    a[i][j] = false
for i in 0..<N: a[x[i]][y[i]] = true

dist[0][0] = 0
var Q = initHeapQueue[S]()
Q.push(S(x:0, y:0, d:0))

while Q.len > 0:
  var e = Q.pop()
  let (x, y, d) = (e.x, e.y, e.d)
  if vis[x][y]: continue
  vis[x][y] = true
  if x == X and y == Y:
    valid = true
    echo d;break
  for p in dir:
    let (x2, y2) = (x + p[0], y + p[1])
    if x2 notin -D..D or y2 notin -D..D: continue
    if a[x2][y2]: continue
    let d2 = d + 1
    if dist[x2][y2] > d2:
      dist[x2][y2] = d2
      Q.push(S(x:x2, y:y2, d:d2))

if not valid:
  echo -1
