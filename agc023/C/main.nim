#{{{ header
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
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ gcd and inverse
const GCD_H = 0

proc gcd(a,b:int):int=
  if b == 0: return a
  else: return gcd(b,a mod b)
proc lcm(a,b:int):int=
  return a div gcd(a, b) * b
# a x + b y = gcd(a, b)
proc extgcd(a,b:int, x,y:var int):int =
  var
    g = a
  x = 1
  y = 0
  if b != 0:
    g = extgcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g;

proc invMod(a,m:int):int =
  var
    x,y:int
  if extgcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
#}}}

const MOD = 1_000_000_007
#{{{ Mint
type Mint = object
  v:int
proc newMint[T](a:T):Mint =
  return Mint(v:a mod MOD)
proc newMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.v += newMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= newMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= newMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
when declared(GCD_H):
  proc `/=`[T](a:var Mint,b:T):void =
    a.v *= invMod(newMint(b).v,MOD)
    a.v = a.v mod MOD
  proc `/`[T](a:Mint,b:T):Mint =
    var c = a
    c /= b
    return c
#}}}

#{{{ fact, comb, perm
var
  factorial_val = @[newMint(1)]
  comb_val = @[@[newMint(1)]]

proc fact(n:int):Mint =
  for i in len(factorial_val)..n:
    factorial_val.add(factorial_val[i-1] * i)
  return factorial_val[n]
proc comb_memo(n,r:int):Mint =
  if n<0 or r<0 or n<r:
    return newMint(0)
  while comb_val.len < n + 1:
    var t = comb_val.len
    comb_val.add(newSeqWith(t + 1, newMint(0)))
    comb_val[t][0] = newMint(1)
    comb_val[t][t] = newMint(1)
    for i in 1..t-1:
      comb_val[t][i] = comb_val[t-1][i-1] + comb_val[t-1][i]
  return comb_val[n][r]

when declared(GCD_H):
  proc comb(n,r:int):Mint =
    if n<0 or r<0 or n<r:
      return newMint(0)
    else:
      return fact(n)/(fact(r)*fact(n-r))
  proc perm(n,r:int):Mint =
    if n<0 or n<r:
      return newMint(0)
    else:
      return fact(n)/fact(n-r)
#}}}


proc main():void =
  var
    N = nextInt()
    ans = newMint(0)
    sum0 = newMint(0)
  if N == 2:
    echo 1
    return
  for k in 0..N-2:
    var
      sum = newMint(0)
    block:
      var
        t = N - 2 - (2 * (k-1) + 3)
      if k >= 1 and t >= 0:
        sum += comb(t + k, k) * 2 * k
    block:
      var
        t = N - 2 - (2 * (k-2) + 4)
      if k >= 2 and t >= 0:
        sum += comb(t + k - 1, k - 1) * (k-1)
    block:
      var
        t = N - 4 - 2 * (k - 1)
      if k >= 1 and t >= 0:
        sum += comb(t + k - 1, k - 1) * 2
    block:
      var
        t = N - 3 - (2 * k)
      if t >= 0:
        sum += comb(t + k, k) * 2
    sum *= fact(N - 2 - k) * fact(k)
    sum0 += sum
    ans += sum * (N - 1 - k)
  echo ans
  return

main()

