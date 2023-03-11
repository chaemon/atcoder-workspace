#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
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
    n = nextInt()
    k = nextInt()
    dp = newSeqWith(n+1,newSeqWith(n+1,newSeqWith(n*n+1,newMint(0))))
  let
    JMAX = n
    SMAX = n*n
  dp[0][0][0] = newMint(1)
  for i in 0..n-1:
    for j in 0..<dp[i].len:
      for s in 0..<dp[i][j].len:
        if dp[i][j][s].v == 0:
          continue
        var s2 = s + j * 2
        if s2 > SMAX:
          continue
        block: # new
          var
            j2 = j + 1
          if j2 <= JMAX:
            dp[i+1][j2][s2] += dp[i][j][s]
        block: # use old
          var
            j2 = j
          dp[i+1][j2][s2] += dp[i][j][s] * j * 2
        block: # stop
          if j > 0:
            var
              j2 = j - 1
            dp[i+1][j2][s2] += dp[i][j][s] * j * j
        block: # itself
          dp[i+1][j][s2] += dp[i][j][s]
  echo dp[n][0][k]
  discard

main()

