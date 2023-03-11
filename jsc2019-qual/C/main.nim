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

const MOD = 1_000_000_007

#{{{ Mint
type Mint = object
  v:int
proc newMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
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


proc solve(N:int, S:string) =
  var
    ct = 1
    ans = newMint(1)
    prev = true # true: start, false: end
  if S[0] == 'W':
    echo 0
    return
  for i in 1..<N*2:
    if S[i] == S[i-1]:
      prev = (not prev)
#    echo i," ",prev, " ", ct
    if not prev:
      if ct == 0:
        echo 0
        return
      ans *= ct
      ct -= 1
    else:
      ct += 1
  if ct != 0:
    echo 0
  else:
    echo ans * fact(N)
  return

proc main() =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
