#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

import sugar

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

var D:int
var L:int
var N:int
var C:seq[int]
var K:seq[int]
var F:seq[int]
var T:seq[int]

#{{{ input part
proc main()
block:
  D = nextInt()
  L = nextInt()
  N = nextInt()
  C = newSeqWith(D, nextInt() - 1)
  K = newSeqWith(N, 0)
  F = newSeqWith(N, 0)
  T = newSeqWith(N, 0)
  for i in 0..<N:
    K[i] = nextInt() - 1
    F[i] = nextInt() - 1
    T[i] = nextInt()
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

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  doAssert(f(r))
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  doAssert(f(l))
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}

let B = 10^5
X := newSeq[seq[int]](B)
Y := newSeq[CumulativeSum[int]](B)

proc forward(K, i, T:int):int =
  if T == 0: return 0
  dump(T)
  dump(i)

  proc f(j:int):bool =
    return Y[K][i..j] <= T
  let j = f.findLast(i..X[K].len)
  dump(j)
  dump(Y[K][i..j])
  dump(j - i)
  return j - i + 1


proc calc(K, F, T:int):int =
  var T = T
  if X[K].len == 0:
    return 0
  var
    i:int
    d:int
    f = 0
  if F > X[K][^1]:
    i = 0
    d = X[K][0] + D - F
  else:
    i = X[K].lowerBound(F)
    d = X[K][i] - F
  if d > 0:
    T -= (d - 1) div L + 1
  if T <= 0: return 0
  dump(T)
  dump(i)
  dump(X[K])
  # starting with X[i] use T times
  if i != 0:
    let t = Y[K][i..<X[K].len]
    if t > T:
      return forward(K, i, T)
    T -= t
    f += X[K].len - i
    i = 0
  # starting with X[0] use T times
  echo "starting with X[0] use T times"
  dump(T)
  dump(i)
  dump(f)
  dump(X[K])
  let S = Y[K][0..X[K].len]
  if T >= S:
    let q = T div S
    dump(S)
    dump(q)
    f += q * X[K].len
    T -= q * S
  doAssert(T < S)
  dump(f)
  dump(T)
  dump(X[K])
  dump(Y[K])
  f += forward(K, 0, T)
  return f

proc main() =
  for i,c in C:
    X[c].add(i)
  for c in 0..<B:
    if X[c].len == 0: continue
    Y[c] = initCumulativeSum[int]()
    for i in 0..<X[c].len:
      if i == X[c].len - 1:
        Y[c][i] = (X[c][0] + D - X[c][i] - 1) div L + 1
      else:
        Y[c][i] = (X[c][i + 1] - X[c][i] - 1) div L + 1

  for i in 0..<N:
    d := F[i] div D
    F[i] -= d * D
    T[i] -= d * D
    print calc(K[i], F[i], T[i])
  return

main()
