#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) == 255:
      break
    elif int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
proc infinity[T]():T =
  return (T(1) shl T(sizeof(T)*8-2))-1
#}}}

#{{{ gcd and inverse
#define __GCD_H
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

proc `+=`[T](a:var Mint,b:T):void =
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

proc fact(n:int):Mint =
  for i in len(factorial_val)..n:
    factorial_val.add(factorial_val[i-1] * i)
  return factorial_val[n]

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
    H = nextInt()
    D = nextInt()
    dp = newSeqWith(H+1,newMint(0))
    fact_sum = newMint(0)
    dp_sum = newMint(0)
  for i in 1..N:
    fact_sum += fact(i)
  dp[0] = fact(N)
  dp_sum += dp[0]
  for i in 1..H:
    dp[i] = dp_sum
    if i < H:
      dp[i] *= fact_sum
    dp_sum += dp[i]
    if i >= D:
      dp_sum -= dp[i-D]
  echo dp[H].v
  discard

main()

