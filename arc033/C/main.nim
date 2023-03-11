# header {{{
{.hints:off checks:off warnings:off assertions:on optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, strformat, sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc discardableId[T](x: T): T {.discardable.} =
  return x

macro `:=`(x, y: untyped): untyped =
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

var Q:int
var T:seq[int]
var X:seq[int]

# input part {{{
proc main()
block:
  Q = nextInt()
  T = newSeqWith(Q, 0)
  X = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    X[i] = nextInt()
#}}}

{.hints:off.}
# {{{ RandomizedBinarySearchTree
import sugar, random, strutils

proc isUpdateData(t:typedesc):bool {.compileTime.} = t.updateData isnot void
#proc hasData(t:typedesc):bool {.compileTime.} = t.D isnot void
proc hasLazy(t:typedesc):bool {.compileTime.} = t.L isnot void
proc hasP(t:typedesc):bool {.compileTime.} = t.useP isnot void
#proc isPersistent(t:typedesc):bool {.compileTime.} = t.Persistent isnot void

type RandomizedBinarySearchTree[D,L,useP,updateData] = object of RootObj
  when D isnot void:
    f:(D,D)->D
    D0:D
  when L isnot void:
    h:(L,L)->L
    g:(D,L)->D
    L0:L
  when useP isnot void:
    p:(L,Slice[int])->L
  r:Rand
  id_max:int

type Node[D, L] = ref object
  cnt:int
  l,r:Node[D, L]
  key, sum:D
  when L isnot void:
    lazy:L
  id:int

proc initNode[RBST](self:RBST, k:RBST.D, p:RBST.L, id:int):auto = Node[RBST.D, RBST.L](cnt:1, key:k, sum:k, lazy:p, l:nil, r:nil, id:id)
proc initNode[RBST](self:RBST, k:RBST.D, id:int):auto = Node[RBST.D, RBST.L](cnt:1, key:k, sum:k, l:nil, r:nil, id:id)

#vector< Node > pool;
#int ptr;
proc initRandomizedBinarySearchTree[D](seed = 2019):auto =
  RandomizedBinarySearchTree[D,void,void,void](r:initRand(seed), id_max:0)
proc initRandomizedBinarySearchTree[D](f:(D,D)->D, D0:D, seed = 2019):auto =
  RandomizedBinarySearchTree[D,void,void,int](f:f, D0:D0, r:initRand(seed), id_max: 0)
proc initRandomizedBinarySearchTree[D,L](f:(D,D)->D, g:(D,L)->D, h:(L,L)->L, D0:D, L0:L, seed = 2019):auto =
  RandomizedBinarySearchTree[D,L,void,int](f:f, g:g, h:h, D0:D0, L0:L0, r:initRand(seed), id_max: 0)
proc initRandomizedBinarySearchTree[D, L](f:(D,D)->D, g:(D,L)->D, h:(L,L)->L, p:(L,Slice[int])->L,D0:D,L0:L,seed = 2019):auto =
  RandomizedBinarySearchTree[D,L,int,int](f:f, g:g, h:h, p:p, D0:D0, L0:L0, r:initRand(seed), id_max: 0)

proc alloc[RBST](self: var RBST, key:RBST.D):auto =
  when RBST.hasLazy:
    result = self.initNode(key, self.L0, self.id_max)
  else:
    result = self.initNode(key, self.id_max)
  self.id_max.inc
#  return &(pool[ptr++] = Node(key, self.L0));

template clone[D,L](t:Node[D, L]):auto = t

proc count[RBST](self: RBST, t:Node):auto = (if t != nil: t.cnt else: 0)
proc sum[RBST](self: RBST, t:Node):auto = (if t != nil: t.sum else: self.D0)

template update[RBST](self: RBST, t:var Node):Node =
  t.cnt = self.count(t.l) + self.count(t.r) + 1
  when RBST.isUpdateData:
    t.sum = self.f(self.f(self.sum(t.l), t.key), self.sum(t.r))
  t

template propagate[RBST](self: var RBST, t:Node):auto =
  when RBST.hasLazy:
    t = clone(t)
    if t.lazy != self.L0:
      when RBST.hasP:
        var
          li = 0
          ri = 0
      if t.l != nil:
        t.l = clone(t.l)
        t.l.lazy = self.h(t.l.lazy, t.lazy)
        when RBST.hasP: ri = li + self.count(t.l)
        t.l.sum = self.g(t.l.sum, when RBST.hasP: self.p(t.lazy, li..<ri) else: t.lazy)
      when RBST.hasP: li = ri
      t.key = self.g(t.key, when RBST.hasP: self.p(t.lazy, li..<li+1) else: t.lazy)
      when RBST.hasP: li.inc
      if t.r != nil:
        t.r = clone(t.r)
        t.r.lazy = self.h(t.r.lazy, t.lazy)
        when RBST.hasP: ri = li + self.count(t.r)
        t.r.sum = self.g(t.r.sum, when RBST.hasP: self.p(t.lazy, li..<ri) else: t.lazy)
      t.lazy = self.L0
    self.update(t)
  else:
    t

proc merge[RBST](self: var RBST, l, r:Node):auto =
  if l == nil: return r
  elif r == nil: return l
#  when RBST.hasLazy:
  var (l, r) = (l, r)
  if self.r.rand(l.cnt + r.cnt - 1) < l.cnt:
    when RBST.hasLazy:
      l = self.propagate(l)
    l.r = self.merge(l.r, r)
    return self.update(l)
  else:
    when RBST.hasLazy:
      r = self.propagate(r)
    r.l = self.merge(l, r.l)
    return self.update(r)

proc split[RBST](self:var RBST, t:Node, k:int):(Node, Node) =
  if t == nil: return (t, t)
  var t = t
  when RBST.hasLazy:
    t = self.propagate(t)
  if k <= self.count(t.l):
    var s = self.split(t.l, k)
    t.l = s[1]
    return (s[0], self.update(t))
  else:
    var s = self.split(t.r, k - self.count(t.l) - 1)
    t.r = s[0]
    return (self.update(t), s[1])

proc build[RBST](self: var RBST, s:Slice[int], v:seq[RBST.D]):auto =
  let (l, r) = (s.a, s.b + 1)
  if l + 1 >= r: return self.alloc(v[l])
  var (x, y) = (self.build(l..<(l + r) shr 1, v), self.build((l + r) shr 1..<r, v))
  return self.merge(x, y)

proc build[RBST](self: var RBST, v:seq[RBST.D]):auto =
  return self.build(0..<v.len, v);
#  ptr = 0;
#  return build(0, (int) v.size(), v);

proc to_vec[RBST](self: var RBST, r:Node, v:var seq[RBST.D], i:var int) =
  if r == nil: return
  when RBST.hasLazy:
    var r = r
    r = self.propagate(r)
  self.to_vec(r.l, v, i)
  v[i] = r.key
  i.inc
#  *it = r.key;
  self.to_vec(r.r, v, i);

proc to_vec[RBST](self: var RBST, r:Node):auto =
  result = newSeq[RBST.D](self.count(r))
  var i = 0
  self.to_vec(r, result, i)

proc to_string[RBST](self: var RBST, r:Node):string =
  return self.to_vec(r).join(", ")

proc write_tree[RBST](self: var RBST, r:Node, h = 0) =
  if h == 0: echo "========== tree ======="
  if r == nil: return
  when RBST.hasLazy:
    var r = r
    r = self.propagate(r)
  for i in 0..<h: stdout.write "  "
  stdout.write r.id, ": ", r.key, ", ", r.sum
  when RBST.hasLazy:
    stdout.write ", ", r.lazy
  echo ""
  self.write_tree(r.l, h+1)
  self.write_tree(r.r, h+1)
  if h == 0: echo "========== end ======="

proc insert[RBST](self: var RBST, t:var Node, k:int, v:RBST.D) =
  var x = self.split(t, k)
  t = self.merge(self.merge(x[0], self.alloc(v)), x[1]);

proc erase[RBST](self: var RBST, t:var Node, k:int) =
  var x = self.split(t, k)
  t = self.merge(x[0], self.split(x[1], 1)[1])

proc query[RBST](self: var RBST, t:var Node, p:Slice[int]):auto =
  let (a, b) = (p.a, p.b + 1)
  var
    x = self.split(t, a)
    y = self.split(x[1], b - a)
  result = self.sum(y[0])
  var m = self.merge(y[0], y[1])
  t = self.merge(x[0], m)

proc set_propagate[RBST](self:var RBST, t:var Node, s:Slice[int], p:RBST.L) =
  static: assert RBST.hasLazy
  let (a, b) = (s.a, s.b + 1)
  var
    x = self.split(t, a)
    y = self.split(x[1], b - a)
  y[0].lazy = self.h(y[0].lazy, p)
  t = self.merge(x[0], self.merge(self.propagate(y[0]), y[1]))

proc set_element[RBST](self: var RBST, t:var Node, k:int, x:RBST.D) =
  when RBST.hasLazy:
    t = self.propagate(t)
  if k < self.count(t.l): self.set_element(t.l, k, x)
  elif k == self.count(t.l):
    t.key = x
    t.sum = x
  else: self.set_element(t.r, k - self.count(t.l) - 1, x)
  t = self.update(t)

proc len[RBST](self: var RBST, t:Node):auto = self.count(t)
proc empty[RBST](self: var RBST, t:Node):bool = return t == nil
proc makeset[RBST](self: var RBST):Node[RBST.D, RBST.L] = nil 
# }}}


# {{{ OrderedSet and OrderedMultiSet
type OrderedMultiSet[T] = object
  rbst: RandomizedBinarySearchTree[T,void,void,void]
  root: Node[T, void]

proc initOrderedMultiSet[T]():OrderedMultiSet[T] =
  result.rbst = initRandomizedBinarySearchTree[T]()
  result.root = nil
#RBST(sz, [&](T x, T y) { return x; }, T()) {}

proc lower_bound[T](self: var OrderedMultiSet[T], t:var Node, x:T):int =
  if t == nil: return 0
  if x <= t.key: return self.lower_bound(t.l, x)
  return self.lower_bound(t.r, x) + self.rbst.count(t.l) + 1

proc lower_bound[T](self:var OrderedMultiSet[T], x:T):int =
  self.lower_bound(self.root, x)

proc upper_bound[T](self: var OrderedMultiSet[T], t:var Node, x:T):int =
  if t == nil: return 0
  if x < t.key: return self.upper_bound(t.l, x)
  return self.upper_bound(t.r, x) + self.rbst.count(t.l) + 1

proc upper_bound[T](self: var OrderedMultiSet[T], x:T):int =
  self.upper_bound(self.root, x)

proc kth_element[T](self: var OrderedMultiSet[T], t:Node, k:int):T =
  if k < self.rbst.count(t.l): return self.kth_element(t.l, k)
  if k == self.rbst.count(t.l): return t.key
  return self.kth_element(t.r, k - self.rbst.count(t.l) - 1)

proc kth_element[T](self: var OrderedMultiSet[T], k:int):T =
  self.kth_element(self.root, k)

proc insert_key[T](self: var OrderedMultiSet[T], x:T) =
  self.rbst.insert(self.root, self.lower_bound(x), x)

proc erase_key[T](self: var OrderedMultiSet[T], t:var Node, x:T) =
  if self.count(t, x) == 0: return
  self.rbst.erase(t, self.lower_bound(t, x))

proc count[T](self: var OrderedMultiSet[T], x:T):int =
  return self.upper_bound(x) - self.lower_bound(x);

#template< class T >
#struct OrderedSet : OrderedMultiSet< T >
#{
#  using SET = OrderedMultiSet< T >;
#  using RBST = typename SET::RBST;
#  using Node = typename RBST::Node;
#
#  OrderedSet(int sz) : OrderedMultiSet< T >(sz) {}
#
#  void insert_key(Node *&t, const T &x) override
#  {
#    if(SET::count(t, x)) return;
#    RBST::insert(t, SET::lower_bound(t, x), x);
#  }
#};
#
# }}}

proc main() =
  var st = initOrderedMultiSet[int]()
  for i in 0..<Q:
    if T[i] == 1:
      st.insert_key(X[i])
    else:
      let a = st.kth_element(X[i] - 1)
      echo a
      st.rbst.erase(st.root, X[i] - 1)
  return

main()

