#{{{ header
{.hints:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, tables
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

proc naive(N:int, X:string): int=
  proc test(x:int):int =
    var
      y = x
      c = 0
    while true:
      if y mod 2 == 1:
        y = y div 2
      else:
        y = y div 2
        y += (1 shl (N - 1))
      c += 1
      if x == y: return c
  var x = 0
  for i in 0..<N:
    if X[i] == '1': x = (x or (1 shl (N - 1 - i)))
  var tb = initTable[int,int]()
  var ans = 0
  for u in 0..x:
    let t = test(u)
    if t notin tb: tb[t] = 0
    tb[t] += 1
    ans += t
    echo "four: ", u
  echo tb
  return ans

const MOD = 998244353

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

proc main():void =
  let
    N = nextInt()
    Y = nextString()
  var X = newSeq[int](N)
  for i in 0..<N:
    X[i] = if Y[i] == '0':0 else: 1
  var
    pow2 = newSeq[Mint](N*2)
  pow2[0] = newMint(1)
  for i in 1..<pow2.len:
    pow2[i] = pow2[i-1] * 2
  proc calc(k:int): Mint =
    proc calc2(): Mint =
      var x = newSeq[int]()
      for i in 0..<k:
        x.add(X[i])
      for i in 0..<k:
        x.add(1 - x[i])
      for i in 0..<N:
        let b = x[i mod x.len]
        if X[i] == 0 and b == 1: return newMint(0)
        elif X[i] == 1 and b == 0: return newMint(1)
      return newMint(1)
    result = newMint(0)
    for i in 0..<k:
      if X[i] == 0:# only 0
        discard
      else: # 0 or 1
        result += pow2[k - 1 - i]
    result += calc2()
    return
  let
    a = N * 2
  var
    ls = newSeq[int]()
  for d in 1..a:
    if d * d > a: break
    if a mod d == 0:
      ls.add(d)
      if d * d < a:
        ls.add(a div d)
  ls.sort(cmp[int])
#  echo ls
  var
    ans = newMint(0)
    v = newSeq[(int,Mint)]()
  for l in ls:
    if (a div l) mod 2 != 1: continue
    var m = calc(l div 2)
#    echo l, " ",m
    for p in v:
      let
        l2 = p[0]
        m2 = p[1]
      if l mod l2 == 0:
        m -= m2
    v.add((l,m))
    ans += m * l
  echo ans
#  echo naive(N,Y)

main()

