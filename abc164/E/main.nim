#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future, heapqueue
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

var N:int
var M:int
var S:int
var U:seq[int]
var V:seq[int]
var A:seq[int]
var B:seq[int]
var C:seq[int]
var D:seq[int]

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  S = nextInt()
  U = newSeqWith(M, 0)
  V = newSeqWith(M, 0)
  A = newSeqWith(M, 0)
  B = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
    A[i] = nextInt()
    B[i] = nextInt()
  C = newSeqWith(N, 0)
  D = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    D[i] = nextInt()
#}}}

t := 10
var adj = Seq(N, newSeq[tuple[to,A,B:int]]())

for i in 0..<M:
  adj[U[i]].add((V[i], A[i], B[i]))
  adj[V[i]].add((U[i], A[i], B[i]))

let SMAX = 5000

type Node = object
  x, s: int
  t: int
 
proc `<`(a,b:Node):auto = a.t < b.t

var
  dist = Seq(N, SMAX + 1, int.inf)
  vis = Seq(N, SMAX + 1, false)
  Q = initHeapQueue[Node]()

S.min=SMAX
dist[0][S] = 0
Q.push(Node(x:0, s:S, t:0))

ans := Seq(N, int.inf)

while Q.len > 0:
  var e = Q.pop()
  let (x, s, t) = (e.x, e.s, e.t)
  if vis[x][s]: continue
  ans[x].min=t
  vis[x][s] = true
  # exchange
  block:
    let
      s2 = min(s + C[x], SMAX)
      t2 = t + D[x]
    if not vis[x][s2]:
      Q.push(Node(x:x, s:s2, t:t2))
  # move
  for (x2, A, B) in adj[x]:
    if s < A:continue
    let
      s2 = min(SMAX, s - A)
      t2 = t + B
    if not vis[x2][s2]:
      Q.push(Node(x:x2, s:s2, t:t2))

for i,a in ans:
  if i > 0:
    print a
