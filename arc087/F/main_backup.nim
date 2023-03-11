#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int=
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
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

let MOD = 1000000007

#{{{ Graph
type Edge[T] = object
  src,dst:int
  weight:T
  rev:int

proc newEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

type Graph[T] = seq[seq[Edge[T]]]

proc newGraph[T](n:int):Graph[T]=
  var g:Graph[T]
  g = newSeqWith(n,newSeq[Edge[T]]())
  return g

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

#{{{ Mint
type Mint = distinct int
proc newMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(a)
proc newMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.int += newMint(b).int
  if a.int >= MOD:
    a.int -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.int *= newMint(b).int
  int(a) = a.int mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.int == 0: return a
  else: return Mint(MOD - a.int)
proc `-=`[T](a:var Mint,b:T):void =
  a.int -= newMint(b).int
  if a.int < 0:
    a.int += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.int)
when declared(GCD_H):
  proc inv[T](b:T):Mint = 
    return newMint(invMod(newMint(b).int,MOD))
  proc `/=`[T](a:var Mint,b:T):void =
    a.int *= invMod(newMint(b).int,MOD)
    int(a) = a.int mod MOD
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

proc derangement(n:int):Mint =
  if n < 0: return newMint(0)
  elif n == 0: return newMint(1)
  result = newMint(0)
  for k in 2..n:
    if k mod 2 == 0: result += inv(fact(k))
    else: result -= inv(fact(k))
  result *= fact(n)
#  echo n," ",result


proc solve(N:int, x:seq[int], y:seq[int]) =
  var
    G = newGraph[int](N)
    ans = newMint(1)
    size = newSeq[int](N)
  for i in 0..<N-1: G.addBiEdge(x[i],y[i])
  proc dfs(u,p:int) =
    size[u] = 1
    var
      v = newSeq[int]()
      s = 0
    for e in G[u]:
      if e.dst == p: continue
      dfs(e.dst,u)
      s += min(size[e.dst],N - size[e.dst])
      size[u] += size[e.dst]
    if p != -1: s += min(size[u], N - size[u])
    echo "dfs: ",u," ",s
    ans *= derangement(s - 1)*s + derangement(s)*(s + 1)
  dfs(0,-1)
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var x = newSeqWith(N-1, 0)
  var y = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt(1)
    y[i] = nextInt(1)
  solve(N, x, y);
  return

main()
#}}}
