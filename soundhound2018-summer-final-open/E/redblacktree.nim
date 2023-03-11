#{{{ header
{. optimization:speed .}
{. checks:off .}
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


type
  COLOR = enum
    BLACK
    RED
  ArrayPool[T] = ref object
    p:int
    pool:seq[T]

  Node[S,T] = ref object
    l,r: Node[S,T]
    color: COLOR
    level: uint8
    cnt: int
    key, sum: S
    lazy: T
  RedBlackTree[S,T] = ref object
    f: proc(x,y:S):S
    g: proc(x:S,y:T):S
    h: proc(x,y:T):T
    p: proc(x:T,y:int):T
    M1: S
    OM0: T
    pool:ArrayPool[Node[S,T]]
proc newArrayPool[T](n:int):ArrayPool[T] =
  return ArrayPool[T](p:n,pool:newSeqWith(n,))
proc newNode[S,T](k:S, pp:T):Node[S,T] =
  return Node[S,T](key:k, sum:k, l:nil, r:nil, color:BLACK, level:0, cnt:1, lazy:pp)
proc newNode[S,T](l,r:Node[S,T], k:S, pp:T):Node[S,T] =
  return Node[S,T](key:k, color:RED, l:l, r:r, lazy:pp)
proc newNode[S,T]():Node[S,T] =
  return Node[S,T]()
proc newRedBlackTree[S](f:proc(x,y:S):S, M1:S, n:int):RedBlackTree[S,int] =
  return RedBlackTree[S,int](f:f, M1:M1, OM0:0, pool:newArrayPool[Node[S,int]](n))
proc alloc[T](self:var ArrayPool[T]):T =
  result = self.pool[self.p]
  self.p += 1
proc alloc[S,T](self:RedBlackTree[S,T], key:S):Node[S,T] =
  result = self.pool.alloc()
  result.key = key
  result.lazy = self.OM0
proc alloc[S,T](self:RedBlackTree[S,T], l,r:Node[S,T]):Node[S,T] =
  result = self.pool.alloc()
  result.l = l
  result.r = r
  result.key = self.M1
  result.lazy = self.OM0
#  var t = newNode(l, r, self.M1, self.OM0)
  return self.update(result);
proc count[S,T](self:RedBlackTree[S,T], t:Node[S,T]):int =
  if t == nil: return 0
  else: return t.cnt
proc sum[S,T](self:RedBlackTree[S,T], t:Node):S =
  return (if t != nil: t.sum  else: self.M1)
proc update[S,T](self:RedBlackTree[S,T], t:Node[S,T]):Node[S,T] =
  t.cnt = self.count(t.l) + self.count(t.r) + (if t.l == nil or t.r == nil:1 else: 0)
  t.level = if t.l != nil: t.l.level + (if t.l.color == BLACK: 1 else: 0) else: 0
  t.sum = self.f(self.f(self.sum(t.l), t.key), self.sum(t.r))
  return t
proc clone[S,T](self:RedBlackTree[S,T], t:Node[S,T]):Node[S,T] =
  return t

proc propagate[S,T](self:RedBlackTree[S,T], t:Node[S,T]):Node[S,T] =
  return t
#  var t = t
#  t = self.clone(t)
#  if t.lazy != self.OM0:
#    if t.l == nil:
#      t.key = self.g(t.key, t.lazy)
#    else:
#      if t.l != nil:
#        t.l = self.clone(t.l)
#        t.l.lazy = self.h(t.l.lazy, t.lazy)
#        t.l.sum = self.g(t.l.sum, self.p(t.lazy, self.count(t.l)))
#      if t.r != nil:
#        t.r = self.clone(t.r)
#        t.r.lazy = self.h(t.r.lazy, t.lazy)
##        t.r.sum = self.g(self.p(t.lazy, self.count(t.r)), t.r.sum)
#        t.r.sum = self.g(t.r.sum, self.p(t.lazy, self.count(t.r)))
#    t.lazy = self.OM0
#    return self.update(t);
#  else:
#    return t

proc rotate[S,T](self:RedBlackTree[S,T], t:Node[S,T], b:bool):Node[S,T] =
  var t = t
  t = self.propagate(t);
  var s:Node[S,T]
  if b:
    s = self.propagate(t.l)
    t.l = s.r
    s.r = t
  else:
    s = self.propagate(t.r)
    t.r = s.l
    s.l = t
  discard self.update(t)
  return self.update(s);

proc submerge[S,T](self:RedBlackTree[S,T], l,r:Node[S,T]):Node[S,T] =
  var
    (l,r) = (l,r)
  if l.level < r.level:
    r = self.propagate(r);
    var c = self.submerge(l, r.l)
    r.l = c
    if r.color == BLACK and c.color == RED and c.l!=nil and c.l.color == RED:
      r.color = RED
      c.color = BLACK
      if r.r.color == BLACK: return self.rotate(r, true)
      r.r.color = BLACK;
    return self.update(r);
  if l.level > r.level:
    l = self.propagate(l);
    var c = self.submerge(l.r, r)
    l.r = c
    if l.color == BLACK and c.color == RED and c.r!=nil and c.r.color == RED:
      l.color = RED
      c.color = BLACK
      if l.l.color == BLACK: return self.rotate(l, false)
      l.l.color = BLACK
    return self.update(l)
  return self.alloc(l, r);

proc merge[S,T](self:RedBlackTree[S,T], l,r:Node[S,T]):Node[S,T] =
  if l == nil or r == nil: return if l != nil: l else: r
  var c = self.submerge(l,r)
  c.color = BLACK;
  return c

proc split[S,T](self:RedBlackTree[S,T], t:var Node[S,T], k:int):(Node[S,T],Node[S,T]) =
  if t == nil: return (nil,nil)
  t = self.propagate(t);
  if k == 0: return (nil,t)
  if k >= self.count(t): return (t, nil)
  var
    l = t.l
    r = t.r
# CAUTION!!
#  pool.free(t);
  if k < self.count(l):
    var pp = self.split(l, k)
    return (pp[0], self.merge(pp[1], r))
  if k > self.count(l):
    var pp = self.split(r, k - self.count(l))
    return (self.merge(l, pp[0]), pp[1])
  return (l,r)
proc split_range[S,T](self:RedBlackTree[S,T], t:var Node[S,T], p:(int,int)):(Node[S,T],Node[S,T],Node[S,T]) =
  var
    (sl,sr) = self.split(t,p[0])
    (tl,tr) = self.split(sr,p[1] - p[0])
  return (sl,tl,tr)

proc build[S,T](self:RedBlackTree[S,T], l,r:int, v:seq[S]):Node[S,T] =
  if l + 1 >= r: return self.alloc(v[l])
  return self.merge(self.build(l, (l + r) shr 1, v), self.build((l + r) shr 1, r, v))

proc build[S,T](self:RedBlackTree[S,T], v:seq[S]):Node[S,T] =
#  pool.clear();
  return self.build(0, v.len, v)

proc dump[S,T](self:RedBlackTree[S,T], r:Node[S,T], i:int, v:var seq[S], lazy:T):void =
  var lazy = lazy
  if r.lazy != self.OM0: lazy = self.h(lazy, r.lazy)
  if r.l == nil or r.r == nil:
    v[i] = self.g(r.key, lazy)
    i += 1
    return
  self.dump(r.l, i, v, lazy);
  self.dump(r.r, i, v, lazy);

proc dump[S,T](self:RedBlackTree[S,T], r:Node[S,T]):seq[S] =
  var v = newSeq[S](self.count(r))
  self.dump(r, 0, v, self.OM0);
  return v

proc to_string[S,T](self:RedBlackTree[S,T], r:Node[S,T]):string =
  var
    s = self.dump(r)
    ret = ""
  for i in 0..<s.len:
    ret += $(s[i]) & ", "
  return ret

proc insert[S,T](self:RedBlackTree[S,T], t:var Node[S,T], k:int, v:S):void =
  var x = self.split(t, k)
  t = self.merge(self.merge(x[0], self.alloc(v)), x[1])

proc erase[S,T](self:RedBlackTree[S,T], t:var Node[S,T], k:int):S =
  var
    x = self.split(t, k)
    y = self.split(x[1], 1)
    v = self.y[0].key
# CAUTION!!!
#  pool.free(y.first);
  t = self.merge(x[0], y[1])
  return v

proc query[S,T](self:RedBlackTree[S,T], t:var Node[S,T], a,b:int):S =
  var
    x = self.split(t, a)
    y = self.split(x[1], b - a)
    ret = sum(y[0])
  t = self.merge(x[0], self.merge(y[0], y[1]));
  return ret

proc set_propagate[S,T](self:RedBlackTree[S,T], t: var Node[S,T], a,b:int, pp:T): void =
  var
    x = self.split(t, a)
    y = self.split(x[1], b - a)
  y[0].lazy = self.h(y[0].lazy, pp)
  t = self.merge(x[0], self.merge(self.propagate(y[0]), y[1]))

proc set_element[S,T](self:RedBlackTree[S,T], t:var Node[S,T], k:int, x:S):void =
  t = self.propagate(t)
  if t.l == nil:
    t.key = x
    t.sum = x
    return
  if k < self.count(t.l): self.set_element(t.l, k, x)
  else: self.set_element(t.r, k - self.count(t.l), x)
  t = self.update(t)

proc len[S,T](self:RedBlackTree[S,T], t:Node[S,T]):int =
  return self.count(t)

proc empty[S,T](self:RedBlackTree[S,T], t:Node[S,T]):bool =
  return t == nil

proc makeset[S,T](self:RedBlackTree[S,T]):Node[S,T] =
  return nil

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
    rbsts = newSeqWith(M,newRedBlackTree[(Mint,int)](f,(newMint(0),0),N*M*2))
    roots = newSeq[Node[(Mint,int),int]](M)
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

