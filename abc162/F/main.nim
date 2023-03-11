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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
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

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  pos:int
  data: seq[T]

proc initCumulativeSum[T]():CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(1, T(0)), pos:0)
proc `[]=`[T](self: var CumulativeSum[T], k:int, x:T) =
  if k < self.pos: doAssert(false)
  if self.data.len < k + 2:
    self.data.setlen(k + 2)
  for i in self.pos+1..<k:
    self.data[i + 1] = self.data[i]
  self.data[k + 1] = self.data[k] + x
  self.pos = k

proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = initCumulativeSum[T]()
  for i,d in data: result[i] = d

proc sum[T](self: CumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  if s.a > s.b: return T(0)
  return self.sum(s.b + 1) - self.sum(s.a)
#}}}

proc main() =
  var cs0, cs1 = initCumulativeSum[int]()
  for i in countup(0, N - 1, 2):
    cs0[i] = A[i]
  for i in countup(1, N - 1, 2):
    cs1[i] = A[i]
  left_dp := Seq(N + 1, 0)
  left_dp[0] = 0
  block:
    s := 0
    for i in countup(2, N, 2): # number of elements
      # A[i - 2], A[i - 1]
      left_dp[i] = -int.inf
      if i - 1 < N:
        left_dp[i].max= left_dp[i - 2] + A[i - 1]
      s += A[i - 2]
      left_dp[i].max=s
  A.reverse
  right_dp := Seq(N + 1, 0)
  right_dp[0] = 0
  block:
    s := 0
    for i in countup(2, N, 2): # number of elements
      # A[i - 2], A[i - 1]
      right_dp[i] = -int.inf
      if i - 1 < N:
        right_dp[i].max= right_dp[i - 2] + A[i - 1]
      s += A[i - 2]
      right_dp[i].max=s
  A.reverse
  if N mod 2 == 0:
    print left_dp[N]
    return
  ans := -int.inf
  for i in 0..<N:
    if i mod 2 == 1:
      ans.max=cs0[0..<i] + right_dp[N - 2 - i]
    else:
      ans.max=left_dp[i] + cs0[i+2..<N]
  print ans
  return

main()
