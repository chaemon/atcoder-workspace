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

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
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

var N:int
var s:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  s = newSeqWith(N, nextInt())
#}}}

#{{{ sieve_of_eratosthenes
type Eratosthenes = object
  pdiv:seq[int]

proc initEratosthenes(n:int):Eratosthenes =
  var pdiv = newSeq[int](n + 1)
  for i in 2..n:
    pdiv[i] = i;
  for i in 2..n:
    if i * i > n: break
    if pdiv[i] == i:
      for j in countup(i*i,n,i):
        pdiv[j] = i;
  return Eratosthenes(pdiv:pdiv)

proc isPrime(self:Eratosthenes, n:int): bool =
  return n != 1 and self.pdiv[n] == n
#}}}

e := initEratosthenes(3000)
primes := newSeq[int]()
for p in 2..<e.pdiv.len:
  if e.isPrime(p): primes.add(p)

proc factorization(n:int):seq[(int,int)] =
  var n = n
  result = newSeq[(int,int)]()
  for p in primes:
    if p * p > n: break
    var e = 0
    if n mod p == 0:
      while n mod p == 0:
        e.inc
        n = n div p
      result.add((p, e))
  if n > 1:
    p := (math.sqrt(n.float) + 1e-10).int
    if p * p == n:
      result.add((p, 2))
    else:
      result.add((n, 1))

proc dual(v:seq[(int,int)]):seq[(int,int)] =
  result = newSeq[(int,int)]()
  for p in v:
    result.add((p[0], 3 - p[1]))

proc main() =
  tb := initTable[seq[(int,int)], int]()
  for s in s:
    f := factorization(s)
    f2 := newSeq[(int,int)]()
    for p in f:
      let r = p[1] mod 3
      if r == 0: continue
      f2.add((p[0], r))
    tb[f2].inc
#  doassert(false)
  vis := initSet[seq[(int,int)]]()
  ans := 0
  for k,v in tb:
    if k in vis: continue
    if k.len == 0:
      ans.inc
      vis.incl k
    else:
      let d = k.dual
      if d in tb:
        ans += max(v, tb[d])
        vis.incl d
      else:
        ans += v
      vis.incl k
  print ans
  return

main()
