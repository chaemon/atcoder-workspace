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
    if int(c) > int(' '):
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

#{{{ input part
proc main()
block:
  N = nextInt()
#}}}

#{{{ gcd and inverse
proc gcd(a,b:int):int=
  if b == 0: return a
  else: return gcd(b,a mod b)
proc lcm(a,b:int):int=
  return a div gcd(a, b) * b
# a x + b y = gcd(a, b)
proc extGcd(a,b:int, x,y:var int):int =
  var g = a
  x = 1
  y = 0
  if b != 0:
    g = extGcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g;
proc invMod(a,m:int):int =
  var
    x,y:int
  if extGcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
#}}}

# isPrime(x:int) {{{
proc isPrime(x:int):bool =
  if x == 1: return false
  var i = 2
  while i * i <= x:
    if x mod i == 0: return false
    i += 1
  return true
#}}}

proc main() =
  v := newSeq[int]()
  ans := newSeq[(int,int)]()
  ps := newSeq[seq[int]]()
  for p in 2..N:
    if not isPrime(p): continue
    pv := newSeq[int]()
    var m = 1
    while m <= N:
      let m2 = m * p
      if m2 > N: break
      pv.add(m2)
      m = m2
    ps.add(pv)
    v.add(m)
  for ps in ps:
    let
      p = ps[0]
      q = ps[^1]
    var s = 1
    for vi in v:
      if vi == q: continue
      s *= vi.invMod(q)
      s = s mod q
#    for pr in ans:
#      let (d, k) = pr
#      s -= d.invMod(q) * k
#      s = s mod q
#      if s < 0: s += q
    var prod = 1
    for t in ps:
      var r = s mod p
      var d:(int,int)
      if r <= p - r:
        s -= r
        d = (q div prod, r)
      else:
        s += (p - r)
        d = (q div prod, -(p - r))
      if d[1] != 0:
        ans.add(d)
      s = s div p
      prod *= p
      discard
  s := 1.0
  for d in v:
    s /= d.float
  for u in ans:
    let (d, k) = u
    s -= k.float/d.float
  ans.add((1, (s + 1e-9).floor.int))
  ans.sort do (x,y:(int,int)) -> int: -cmp(x[1], y[1])
  let Q = ans.mapIt(it[1].abs).sum
  print Q
  for a in ans:
    let (d, k) = a
    var op:string
    if k == 0: continue
    elif k > 0: op = "+"
    elif k < 0: op = "-"
    for i in 0..<k.abs:
      print op, d
  return

# multisolution {{{
import streams

const CHECK = false

when CHECK:
  var output = newStringStream()
  print = proc(x: varargs[string,toStr]) = output.write(print0(@x,sep = " "))
  proc check() =
    output.flush()
    output.setPosition(0)
    # write check code
  main()
  check()
else:
  main()
# }}}
