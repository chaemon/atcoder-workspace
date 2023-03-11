#{{{ header
{.hints:off warnings:off optimization:speed checks:off.}
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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var Q:int
var A:seq[int]
var S:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  Q = nextInt()
  A = newSeqWith(N, nextInt())
  S = newSeqWith(Q, nextInt())
#}}}

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

proc divisor(n:int):seq[int] =
  result = newSeq[int]()
  var i = 1
  while i * i <= n:
    if n mod i == 0:
      result.add(i)
      if i * i != n: result.add(n div i)
    i += 1
  result.sort(cmp[int])

d := divisor(A[0])

var gcd_tb: array[2048, array[2048, int32]]

proc main() =
  ans := newSeq[int](d.len)
  id := initTable[int,int]()
  for i,d in d:
    id[d] = i
  for i in 1..<N:A[i] = id[gcd(A[0], A[i])]
  for p in d:
    for q in d:
      gcd_tb[id[p]][id[q]] = id[gcd(p, q)].int32
  for j,t in d:
    Xi := -1
    for i in 0..<N:
      if i == 0:
        Xi = id[gcd(t, A[0])]
      else:
        Xi = gcd_tb[Xi][A[i]]
      if Xi == 0:
        ans[j] = i + 1
        break
    if Xi != 0: ans[j] = d[Xi]
  for s in S:
    X := gcd(s, A[0])
    print ans[id[X]]
  return

main()
