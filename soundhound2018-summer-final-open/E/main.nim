#{{{ header
import algorithm, sequtils, strutils
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

#{{{ Xor128
type Xor128 = object
  x,y,z,w:int

proc newXor128():Xor128 =
  return Xor128(x:123456789,y:362436069, z:521288629, w:88675123)

proc next(self:var Xor128):int =
  var t = self.x xor (self.x shl 11)
  self.x = self.y
  self.y = self.z
  self.z = self.w
  self.w = (self.w xor (self.w shr 19)) xor (t xor (t shr 8))
  return self.w

var
  x128 = newXor128()
#}}}

type
  Node[S,T] = ref object
    left,right: Node[S,T]
    cnt: int
    key, sum: S
    lazy: T
  RBST[S,T] = ref object of RootObj
    M1: S
    OM0: T
    f: proc(x,y:S):S
    g: proc(x:S,y:T):S
    h: proc(x,y:T):T
    p: proc(x:T,y:int):T

proc newNode[S, T](k:S, p:T): Node[S, T] = 
  return Node[S, T](cnt:1, key:k, sum:k, lazy:p, left:nil,right:nil)
proc newRBST[S](f:proc(x,y:S):S, M1:S):RBST[S, int] =
  return RBST[S, int](M1:M1,f:f)
proc newRBST[S, T](f:proc(x,y:S):S,g:proc(x:S,y:T):S,h:proc(x,y:T):T,p:proc(x:T,y:int):T,M1:S, OM0:T):RBST[S, T] =
  return RBST[S, T](M1:M1,OM0:OM0,f:f,g:g,h:h,p:p)

proc alloc[S, T](self:RBST[S,T], key:S):Node[S,T] =
  return newNode[S,T](key, self.OM0)

proc clone[S,T](self:RBST[S,T], t:Node[S,T]):Node[S,T] =
  return t

proc count[S,T](self:RBST[S,T], t:Node):int =
  if t != nil: return t.cnt
  else: return 0
proc sum[S,T](self:RBST[S,T], t:Node[S,T]):S =
  if t != nil: return t.sum
  else: return self.M1

proc update[S,T](self:RBST[S,T], t:Node[S,T]):Node[S,T] =
  t.cnt = self.count(t.left) + self.count(t.right) + 1
  t.sum = self.f(self.f(self.sum(t.left), t.key), self.sum(t.right))
  return t
proc propagate[S,T](self:RBST[S,T], t:var Node[S,T]):Node[S,T] =
  if t.lazy != self.OM0:
    t = self.clone(t)
    t.key = self.g(t.key, t.lazy)
    if t.left != nil: 
      t.left = self.clone(t.left)
      t.left.lazy = self.h(t.left.lazy, t.lazy)
      t.left.sum = self.f(t.left.sum, self.p(t.lazy, self.count(t.left)))
    if t.right != nil:
      t.right = self.clone(t.right)
      t.right.lazy = self.h(t.right.lazy, t.lazy)
      t.right.sum = self.f(self.p(t.lazy, self.count(t.right)), t.right.sum)
    t.lazy = self.OM0
    return self.update(t)
  else:
    return t

proc merge[S,T](self:RBST[S,T], l2,r2: Node[S,T]): Node[S,T] =
  if l2 == nil:
    return r2
  elif r2 == nil:
    return l2
  var
    left = l2
    right = r2
  if x128.next() mod (left.cnt + right.cnt) < left.cnt:
#  if random(100000000) mod (left.cnt + right.cnt) < left.cnt:
    left = self.propagate(left)
    left.right = self.merge(left.right, right)
    return self.update(left)
  else:
    right = self.propagate(right);
    right.left = self.merge(left, right.left)
    return self.update(right);

proc split[S,T](self:RBST[S,T], t:var Node[S,T], k:int):(Node[S,T],Node[S,T]) =
  if t == nil:
    return (nil,nil)
  t = self.propagate(t);
  if k <= self.count(t.left):
    var s = self.split(t.left, k)
    t.left = s[1]
    return (s[0], self.update(t))
  else:
    var s = self.split(t.right, k - self.count(t.left) - 1)
    t.right = s[0]
    return (self.update(t), s[1])
proc split_range[S,T](self:RBST[S,T], t:var Node[S,T], p:(int,int)):(Node[S,T],Node[S,T],Node[S,T]) =
  var
    (sl,sr) = self.split(t,p[0])
    (tl,tr) = self.split(sr,p[1] - p[0])
  return (sl,tl,tr)

proc build[S,T](self:RBST[S,T],left,right:int, v: seq[S]):Node[S,T] =
  if left + 1 >= right: return self.alloc(v[left])
  var
    nl = self.build(left, (left + right) shr 1, v)
    nr = self.build((left + right) shr 1, right, v)
  return self.merge(nl, nr)
proc build[S,T](self:RBST[S,T], v: seq[S]):Node[S,T] =
  return self.build(0, v.len, v)
proc dump[S,T](self:RBST[S,T], r:var Node[S,T], i:var int, v:var seq[S]):void =
  if r == nil:
    return
  r = self.propagate(r)
  self.dump(r.left, i, v)
  v[i] = r.key
  i += 1
  self.dump(r.right, i, v)
proc dump[S,T](self:RBST[S,T], r:var Node[S,T]):seq[S] =
  result = newSeq[S](self.count(r))
  var i = 0
  self.dump(r, i, result)
proc to_string[S,T](self:RBST[S,T], r:var Node[S,T]):string =
  var s = self.dump(r)
  result = ""
  for i in 0..<s.len:
    result.add(", " & string(s[i]))
proc insert[S,T](self:RBST[S,T], t: var Node[S,T], k:int, v:S):void =
  var
    x = self.split(t, k)
  t = self.merge(self.merge(x[0], self.alloc(v)), x[1])
proc erase[S,T](self:RBST[S,T], t: var Node[S,T], k:int):void = 
  var x = self.split(t, k);
  t = self.merge(x[0], self.split(x[1], 1)[1])
proc query[S,T](self:RBST[S,T], t: var Node[S,T], a,b:int):S =
  var
    x = self.split(t, a)
    y = self.split(x[1], b - a)
  result = self.sum(y.first);
  t = self.merge(x[0], self.merge(y[0], y[1]));
proc set_propagate[S,T](self:RBST[S,T], t:var Node[S,T], a,b:int, p:T):void =
  var
    x = self.split(t, a)
    y = self.split(x.second, b - a)
  y.first.lazy = self.h(y.first.lazy, p)
  t = self.merge(x.first, self.merge(self.propagate(y.first), y.second))
proc set_element[S,T](self:RBST[S,T], t: var Node[S,T], k:int, x:S):void =
  t = self.propagate(t);
  if k < self.count(t.left): self.set_element(t.left, k, x)
  elif k == self.count(t.left): t.key = t.sum;t.sum = x
  else:
    self.set_element(t.right, k - count(t.left) - 1, x)
  t = update(t)
proc size[S,T](self:RBST[S,T], t:Node[S,T]):int =
  return self.count(t)
proc empty[S,T](self:RBST[S,T], t:Node[S,T]):bool =
  return t == nil
proc makeset[S,T](self:RBST[S,T]):Node[S,T] =
  return nil

type OrderedMultiSet[S] = ref object of RBST[S,S]
  discard
proc newOrderedMultiSet[S]():OrderedMultiSet[S] = 
  return OrderedMultiSet[S](f:proc(x,y:S):S = x,M1:0)
proc kthElement[S](self:OrderedMultiSet[S], t:var Node[S,S], k:int):S =
  if k < self.count(t.left): return self.kthElement(t.left, k)
  if k == self.count(t.left): return t.key
  return self.kthElement(t.right, k - self.count(t.left) - 1)
proc insertKey[S](self:OrderedMultiSet[S], t:var Node[S,S],x:S):void =
  cast[RBST[S,S]](self).insert(t, self.lowerBound(t, x), x)
proc eraseKey[S](self:OrderedMultiSet[S], t:var Node[S,S], x:S):void =
  if self.count(t, x)==0: return
  cast[RBST[S,S]](self).erase(t, self.leftower_bound(t, x))
proc countElement[S](self:OrderedMultiSet[S], t:Node[S,S], x:S):int =
  return self.upperBound(t, x) - lowerBound(t, x)
proc lowerBound[S](self:OrderedMultiSet[S], t:Node[S,S], x:S):int =
  if t == nil: return 0
  if x <= t.key: return self.lowerBound(t.left, x)
  return self.lowerBound(t.right, x) + cast[RBST[S,S]](self).count(t.left) + 1
proc upperBound[S](self:OrderedMultiSet[S], t:Node[S,S], x:S):int=
  if t==nil: return 0
  if x < t.key: return self.upperBound(t.left, x)
  return self.upperBound(t.right, x) + cast[RBST[S,S]](self).count(t.left) + 1

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

proc main():void =
  var
    N,M = nextInt()
    S = newSeqWith(M,nextString())
    Q = nextInt()
    power = newSeq[Mint](N+1)
  block:
    var p = newMint(1)
    for i in 0..<power.len:
      power[i] = p
      p *= 1_000_000
  proc f(x,y:(Mint,int)):(Mint,int) =
    return (x[0] + power[x[1]]*y[0], x[1] + y[1])
  var
    rbsts = newSeqWith(M,newRBST[(Mint,int)](f,(newMint(0),0)))
    roots = newSeq[Node[(Mint,int),(Mint,int)]](M)
  for i in 0..<M:
    var v = newSeq[(Mint,int)](N)
    for j in 0..<N:
      v[j] = (newMint(ord(S[i][j])-ord('a')+1),1)
    roots[i] = rbsts[i].build(v)
  for _ in 0..<Q:
    var
      t,x,y,l,r = nextInt()
    if t == 1:
      x -= 1;y -= 1;l -= 1
      var
        (ax,bx,cx) = rbsts[x].split_range(roots[x],(l,r))
        (ay,by,cy) = rbsts[y].split_range(roots[y],(l,r))
      roots[x] = rbsts[x].merge(rbsts[x].merge(ax,by),cx)
      roots[y] = rbsts[y].merge(rbsts[y].merge(ay,bx),cy)
    else:
      x -= 1;l -= 1;
      var
        (ax,bx,cx) = rbsts[x].split_range(roots[x],(l,r))
      stdout.write(bx.sum[0])
      stdout.write("\n")
      roots[x] = rbsts[x].merge(rbsts[x].merge(ax,bx),cx)
    discard
main()

