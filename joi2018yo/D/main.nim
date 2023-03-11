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
#}}}

var N:int
var L:seq[int]

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  built:bool
  data: seq[T]

proc initCumulativeSum[T](sz:int = 100):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(sz + 1, T(0)), built:false)
proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = CumulativeSum[T](data: @[T(0)] & data, built:false)
  result.build()
proc add[T](self: var CumulativeSum[T], k:int, x:T) =
  if self.data.len < k + 2:
    self.data.setlen(k + 2)
  self.data[k + 1] += x

proc build[T](self: var CumulativeSum[T]) =
  self.built = true
  for i in 1..<self.data.len:
    self.data[i] += self.data[i - 1];

proc sum[T](self: CumulativeSum[T], k:int):T =
  assert(self.built)
  if k < 0: return T(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  assert(self.built)
  if s.a > s.b: return T(0)
  return self.sum(s.b + 1) - self.sum(s.a)
#}}}

#{{{ input part
proc main()
block:
  N = nextInt()
  L = newSeqWith(N, nextInt())
#}}}

proc main() =
  ans := int.inf
  cs := initCumulativeSum(L)
  for i in 0..<N:
    for j in i..<N:
      if i == 0 and j == N - 1: continue
      # i..j: min
      let min_val = cs[i..j]
      var dp = newSeq[int](N)
      dp[i] = 0
      dp[j] = 0
      for l in countdown(i - 1, 0):
        dp[l] = int.inf
        for k in l..i - 1:
          # l..k, k+1..<i
          if cs[l..k] < min_val: continue
          dp[l].min=max(dp[k + 1], cs[l..k] - min_val)
      for r in countup(j + 1, N - 1):
        dp[r] = int.inf
        for k in j + 1..r:
          # j..k-1, k..r
          if cs[k..r] < min_val: continue
          dp[r].min=max(dp[k-1], cs[k..r] - min_val)
      ans.min=max(dp[0], dp[N-1])
  print ans
  return

main()
