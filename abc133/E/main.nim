import sequtils, tables
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

#{{{ gcd and inverse
const GCD {.booldefine.}: bool = true
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
  if (extgcd(a, m, x, y) == 1): return (x + m) mod m
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
#when defined(GCD_H):
when true:
  proc `/=`[T](a:var Mint,b:T):void =
    a.v *= invMod(newMint(b).v,MOD)
    a.v = a.v mod MOD
  proc `/`[T](a:Mint,b:T):Mint =
    var c = a
    c /= b
    return c
#}}}


#template<class T>
#T& operator <<(T &os, const Mint &n){
#	os<<(int)n.v;
#	return os;
#}
#
#template<class T>
#T& operator >>(T &is, Mint &n){
#	long long v;is >> v;
#	n = Mint(v);
#	return is;
#}
#//}}}

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

var
  N = nextInt()
  K = nextInt()
  g = newSeqWith(N,newSeqWith(0,0))

for i in 0..N-2:
  var
    a = nextInt()
    b = nextInt()
  a -= 1
  b -= 1
  g[a].add(b)
  g[b].add(a)

proc dfs(u:int=0,p:int= -1):Mint =
  var
    t = newMint(1)
    r = 0
    c:int
  if u == 0:
    c = K - 1
  else:
    c = K - 2
  
  for v in g[u]:
    if v == p:
      continue
    t *= dfs(v,u)
    r += 1
  t *= perm(c,r)
#  echo u," ",t
  return t

if K == 1:
  if N == 1:
    echo K
  else:
    echo 0
elif K == 2:
  if N == 1:
    echo K
  elif N == 2:
    echo K*(K-1) mod MOD
else:
  echo((dfs()*K).v)
