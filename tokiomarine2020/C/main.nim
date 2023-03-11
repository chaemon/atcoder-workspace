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

template SeqImpl(lens: seq[int]; init; d: int): auto =
  when d + 1 == lens.len:
    when init is typedesc: newSeq[init](lens[d])
    else: newSeqWith(lens[d], init)
  else: newSeqWith(lens[d], SeqImpl(lens, init, d + 1))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 0)

template ArrayImpl(lens: varargs[int]; init: typedesc; d: int): typedesc =
  when d + 1 == lens.len: array[lens[d], init]
  else: array[lens[d], ArrayImpl(lens, init, d + 1)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 0).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 0)
    ArrayFill(a, init)
    a
#}}}

var N:int
var K:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

# CumulativeSum (Imos){{{
import sequtils

type DualCumulativeSum[T] = object
  pos: int
  data: seq[T]

proc initDualCumulativeSum[T](sz:int = 100):DualCumulativeSum[T] = DualCumulativeSum[T](data: newSeqWith(sz, T(0)), pos: -1)
proc initDualCumulativeSum[T](a:seq[T]):DualCumulativeSum[T] =
  var data = a
  data.add(T(0))
  for i in 0..<a.len:
    data[i + 1] -= a[i]
  return DualCumulativeSum[T](data: data, pos: -1)
proc add[T](self: var DualCumulativeSum[T], s:Slice[int], x:T) =
  assert(self.pos < s.a)
  if s.a > s.b: return
  if self.data.len <= s.b + 1:
    self.data.setlen(s.b + 1 + 1)
  self.data[s.a] += x
  self.data[s.b + 1] -= x

proc `[]`[T](self: var DualCumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  if self.data.len <= k:
    self.data.setlen(k + 1)
  while self.pos < k:
    self.pos += 1
    if self.pos > 0: self.data[self.pos] += self.data[self.pos - 1]
  return self.data[k]
#}}}

proc main() =
  for i in 0..<K:
    B := newSeq[int](N)
    cs := initDualCumulativeSum[int](N)
    for i in 0..<N:
      cs.add(max(0, i - A[i])..i + A[i], 1)
    for i in 0..<N:
      B[i] = cs[i]
    if B == A:
      break
    swap(A, B)
  print A
  return

main()
