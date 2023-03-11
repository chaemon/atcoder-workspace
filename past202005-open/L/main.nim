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

import heapqueue

type S = object
  i,j:int
  T:int

proc `<`(a,b:S):bool = a.T > b.T

proc main() =
  let N = nextInt()
  var
    c = Seq(N, seq[S])
    head = Seq(N, seq[int])
    front = Seq(N, 0)
    bought = initSet[(int,int)]()
  for i in 0..<N:
    let K = nextInt()
    for j in 0..<K:
      let T = nextInt()
      c[i].add(S(i:i,j:j,T:T))
  var q, q2 = initHeapQueue[S]()
  for i in 0..<N:
    q.push(c[i][0])
    q2.push(c[i][0])
    head[i].add(0)
    front[i] = 1
    if c[i].len > 1:
      q2.push(c[i][1])
      head[i].add(1)
      front[i] = 2
  let M = nextInt()
  for _ in 0..<M:
    let a = nextInt()
    var i0, j0:int
    if a == 1:
      while true:
        let s = q.pop()
        let (i,j,T) = (s.i,s.j,s.T)
        if (i,j) notin bought:
          i0 = i
          j0 = j
          break
    else:
      while true:
        let s = q2.pop()
        let (i,j,T) = (s.i,s.j,s.T)
        if (i,j) notin bought:
          i0 = i
          j0 = j
          break
    echo c[i0][j0].T
    bought.incl((i0, j0))
    # buy (i0, j0)
    var p = head[i0].find(j0)
    doAssert(p != -1)
    if p == 0:
      if head[i0].len >= 2:
        head[i0][0] = head[i0][1]
        q.push(c[i0][head[i0][0]])
        p.inc
      else:
        discard head[i0].pop()
    if p == 1:
      # take
      var j = -1
      while front[i0] < c[i0].len:
        let c0 = c[i0][front[i0]]
        front[i0].inc
        if (c0.i, c0.j) notin bought:
          j = c0.j
          break
      if j == -1: # nothing
        head[i0].setlen(1)
      else:
        head[i0][1] = j
        q2.push(c[i0][j])
#    else:
#      doAssert(false)
  return

main()
