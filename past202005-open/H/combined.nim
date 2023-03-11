#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
import sugar
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
var L:int
var x:seq[int]
var T:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  L = nextInt()
  x = newSeqWith(N, nextInt())
  T = newSeqWith(3, nextInt())
#}}}

proc main() =
  ans := int.inf
  dp := Seq(L + 10, int.inf)
  h := Seq(L + 10, false)
  for i in 0..<N:
    h[x[i]] = true
  dp[0] = 0
  for d in 0..<L:
    # run
    block:
      t := dp[d] + T[0]
      if h[d + 1]: t += T[2]
      dp[d + 1].min=t
      if d + 1 == L:
        ans.min=dp[d + 1]
    # jump1
    block:
      t := dp[d] + T[1] + T[0]
      if h[d + 2]: t += T[2]
      dp[d + 2].min=t
      if d + 2 == L:
        ans.min=dp[d+2]
      elif d + 2 > L:
        let diff = d + 2 - L
        ans.min=dp[d+2] - (diff * 2 - 1) * (T[1] div 2) - (T[0] div 2)
    # jump3
    block:
      t := dp[d] + T[1] * 3 + T[0]
      if h[d + 4]: t += T[2]
      dp[d + 4].min=t
      if d + 4 == L:
        ans.min=dp[d+4]
      elif d + 4 > L:
        let diff = d + 4 - L
        ans.min=dp[d+4] - (diff * 2 - 1) * (T[1] div 2) - (T[0] div 2)
  echo ans
  return

main()
