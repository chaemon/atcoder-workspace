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

template ArrayImpl(lens: varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template Array(lens: varargs[int]; init: typedesc): auto =
  ArrayImpl(@lens, init, 1, lens.len).default
#}}}

var a = Array(3, 4, 5, int)

#{{{ toInt(seq[int], b = 10), toSeq(n: int, b = 10, min_digit)
proc toInt(d: seq[int], b = 10):int =
  result = 0
  var p = 1
  for di in d:
    result += p * di
    p *= b
proc toSeq(n: int, b = 10, min_digit = -1):seq[int] =
  result = newSeq[int]()
  var n = n
  while n > 0:result.add(n mod b); n = n div b
  if min_digit >= 0:
    while result.len < min_digit: result.add(0)
#}}}

var N:int
var T:string

#{{{ input part
proc main()
block:
  N = nextInt()
  T = nextString()
#}}}

proc naive():seq[int] =
  result = newSeq[int](3^N)
  for i in 0..<3^N: result[i] = i
  for t in T:
    var result2 = newSeq[int](3^N)
    if t == 'S':
      for i in 0..<3^N:
        var u = toSeq(i, 3)
        for j in 0..<u.len:
          if u[j] != 0: u[j] = 3 - u[j]
        result2[u.toInt(3)] = result[i]
    else:
      for i in 0..<3^N:
        result2[(i + 1) mod 3^N] = result[i]
    swap(result, result2)
  var a = newSeq[int](3^N)
  for i in 0..<a.len:
    a[result[i]] = i
  return a

proc main() =
  let B = 3^N
  var
    a = newSeq[int](B)
    b = newSeq[int](B)
    sgn = 1
    p = 0
    d = 0
  for i in 0..<T.len:
    if T[i] == 'S':
      a[p] += sgn
      sgn *= -1
      dump(sgn)
      dump(p)
      d *= -1
    else:
      d += 1
      p.inc
    if p == B: p = 0
  if sgn == 1:
    for i in 0..<a.len:
      a[i] *= -1
  for i in 0..<b.len:
    var
      c = toSeq(i, 3, N)
      s = 0
    for j in 0..<N:
      if c[j] > 0: s += 3^(j + 1)
    b[i] = s
  var ans = newSeq[int](B)
  for i in 0..<B:
    ans[i] = 0
    for j in 0..<B:
      ans[i] += b[(i + j) mod B] * a[j]
      ans[i] = ans[i] mod B
      ans[i] += B
      ans[i] = ans[i] mod B
    ans[i] += d
    ans[i] += i * sgn
    ans[i] = ((ans[i] mod B) + B) mod B
  dump(a)
  dump(b)
  dump(d)
  dump(ans)
  dump(naive())
  return

main()
