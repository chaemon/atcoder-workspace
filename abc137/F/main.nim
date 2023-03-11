import sequtils,strutils
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

var MOD = -1
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

#{{{ polynomial class
type poly[T] = seq[T]

proc `+=`[T](self:var poly[T],p:poly[T]):void =
  self.setlen(max(self.len,p.len))
  for i in 0..<p.len: self[i] += p[i]
proc `+`[T](p,q:poly[T]):poly[T] =
  result = p
  result += q
proc `-=`[T](self:var poly[T],p:poly[T]):void =
  self.setlen(max(self.len,p.len))
  for i in 0..<p.len: self[i] -= p[i]
proc `-`[T](p,q:poly[T]):poly[T] =
  result = p
  result -= q
proc `*`[T](p,q:poly[T]):poly[T] =
  result = poly[T](newSeqWith(p.len + q.len - 1, T()))
  for i in 0..<p.len:
    for j in 0..<q.len:
      result[i + j] += p[i] * q[j]
proc `*=`[T](self:var poly[T],q:poly[T]):void =
  self = self * q
proc apply[T](p:poly[T],a:T):T = 
  result = T()
  for i in countdown(p.len - 1, 0):
    result *= a
    result += p[i]
proc `$`[T](self:poly[T]):string =
  var v = newseq[string](0)
  for d in countdown(self.len-1,0):
    v.add($self[d] & "*x^" & $d)
  return v.join(" + ")
proc `divmod`[T](a,b:poly[T]):(poly[T],poly[T]) =
  if a.len < b.len: return (poly[T](newSeqWith(1,T())),a)
  assert a.len >= b.len
  var
    a = a
    q = newSeq[T](a.len - b.len + 1)
  for i in countdown(q.len - 1,0):
    q[i] = a[i+b.len-1] / b[^1]
    for j in 0..<b.len:
      a[i + j] -= q[i] * b[j]
  return (q, a[0..b.len-1])
#}}}

proc solve(p:int, a:seq[int]):void =
  MOD = p
  var v = newseq[Mint](0)
  for i in 0..p-1:
    var s = newMint(a[i])
    for j in 0..<v.len:
      s -= v[j]
      s /= i - j
    v.add(s)
  var q:poly[Mint] = @[newMint(0)]
  for i in countdown(p-1,0):
    if i != p - 1:
      q *= @[newMint(-i),newMint(1)]
    q += @[v[i]]
  for i in 0..p-1:
    stdout.write q[i]," "
  echo ""

proc test() =
  MOD = 13
  var
    a = [3,1,4,1,5].map(newMint)
    b = [9,2,6].map(newMint)
  block:
    let (q, r) = divmod(a,b)
    echo a
    echo b * q + r
  block:
    let (q, r) = divmod(b,a)
    echo b
    echo a * q + r

  return

proc main():void =
  test()
  var p = 0
  p = nextInt()
  var a = newSeqWith(p-1-0+1, 0)
  for i in 0..<p-1-0+1:
    a[i] = nextInt()
  solve(p, a);
  return

main()
