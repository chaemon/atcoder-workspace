#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type someSignedInt = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someInteger = someSignedInt|someUnsignedInt
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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
#}}}

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

proc reduce_consective[T](v:seq[T]): seq[(T,int)] =
  result = newSeq[(T,int)]()
  var i = 0
  while i < v.len:
    var j = i
    while j < v.len and v[i] == v[j]: j += 1
    result.add((v[i], j - i))
    i = j
  discard

const MOD = 1_000_000_007

#{{{ Mint
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type Mint = object
  v:int
proc initMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
proc init[T](self:Mint, a:T):Mint = initMint(a)
proc initMint(a:Mint):Mint = a
proc Identity(self:Mint):Mint = return initMint(1)
proc `+=`[T](a:var Mint, b:T):void =
  a.v += initMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= initMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= initMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
proc `==`(a:Mint, b:Mint):bool = a.v == b.v
proc `!=`(a:Mint, b:Mint):bool = a.v != b.v
proc pow(x:Mint, n:int):Mint =
  var (x,n) = (x,n)
  result = initMint(1)
  while n > 0:
    if (n and 1) > 0: result *= x
    x *= x
    n = (n shr 1)
proc inverse(x:int):Mint =
  var (a, b) = (x, MOD)
  var (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initMint(u)
proc `/=`[T](a:var Mint,b:T):void =
  a *= initMint(b).v.inverse()
proc `/`[T](a:Mint,b:T):Mint =
  var c = a
  c /= b
  return c
#}}}

proc test(v:array[4,int]):bool =
  for i in 0..3:
    var w = v
    if i != 3: swap(w[i], w[i+1])
    if w[0] == 0 and w[1] == 1 and w[2] == 2: return false
    if w[1] == 0 and w[2] == 1 and w[3] == 2: return false
  return true

proc solve(N:int) =
  var dp = newSeqWith(4, 4, 4, initMint(1))
  dp[2][1][0] = initMint(0)
  dp[1][2][0] = initMint(0)
  dp[2][0][1] = initMint(0)
  for d in 4..N:
    var dp2 = newSeqWith(4, 4, 4, initMint(0))
    for p in 0..3:
      for q in 0..3:
        for r in 0..3:
          for s in 0..3:
            if test([p,q,r,s]):
              dp2[s][r][q] += dp[r][q][p]
    swap(dp2, dp)
  var ans = initMint(0)
  for p in 0..3:
    for q in 0..3:
      for r in 0..3:
        ans += dp[p][q][r]
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  solve(N);
  return

main()
#}}}
