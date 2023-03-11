when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
  when not declared ATCODER_READER_HPP:
    const ATCODER_READER_HPP* = 1
    import streams
    import strutils
    import sequtils
    proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
    #proc getchar(): char {.header: "<stdio.h>", varargs.}
    proc nextInt*(): int = scanf("%lld",addr result)
    proc nextFloat*(): float = scanf("%lf",addr result)
    proc nextString*[F](f:F): string =
      var get = false
      result = ""
      while true:
    #    let c = getchar()
        let c = f.readChar
        if c.int > ' '.int:
          get = true
          result.add(c)
        elif get: return
    proc nextInt*[F](f:F): int = parseInt(f.nextString)
    proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
    proc nextString*():string = stdin.nextString()
  
    proc toStr*[T](v:T):string =
      proc `$`[T](v:seq[T]):string =
        v.mapIt($it).join(" ")
      return $v
    
    proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
      result = ""
      for i,v in x:
        if i != 0: addSep(result, sep = sep)
        add(result, v)
      result.add("\n")
      stdout.write result
    
    var print*:proc(x: varargs[string, toStr])
    print = proc(x: varargs[string, toStr]) =
      discard print0(@x, sep = " ")
    discard
  when not declared ATCODER_SLICEUTILS_HPP:
    const ATCODER_SLICEUTILS_HPP* = 1
    proc index*[T](a:openArray[T]):Slice[int] =
      a.low..a.high
    type ReversedSlice[T] = distinct Slice[T]
    type StepSlice[T] = object
      s:Slice[T]
      d:T
    proc reversed*[T](p:Slice[T]):auto = ReversedSlice[T](p)
    iterator items*[T](p:ReversedSlice[T]):T =
      var i = Slice[T](p).b
      while true:
        yield i
        if i == Slice[T](p).a:break
        i.dec
    proc `>>`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d:d)
    proc `<<`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d: -d)
    proc low*[T](s:StepSlice[T]):T = s.s.a
    proc high*[T](s:StepSlice[T]):T =
      let p = s.s.b - s.s.a
      if p < 0: return s.low - 1
      let d = abs(s.d)
      return s.s.a + (p div d) * d
    iterator items*[T](p:StepSlice[T]):T = 
      assert p.d != 0
      if p.s.a <= p.s.b:
        if p.d > 0:
          var i = p.low
          let h = p.high
          while true:
            yield i
            if i == h: break
            i += p.d
        else:
          var i = p.high
          let l = p.low
          while true:
            yield i
            if i == l: break
            i += p.d
    proc `[]`*[T:SomeInteger, U](a:openArray[U], s:Slice[T]):seq[U] =
      for i in s:result.add(a[i])
    proc `[]=`*[T:SomeInteger, U](a:var openArray[U], s:StepSlice[T], b:openArray[U]) =
      var j = 0
      for i in s:
        a[i] = b[j]
        j.inc
    discard
  when not declared ATCODER_MAX_MIN_OPERATOR_HPP:
    const ATCODER_MAX_MIN_OPERATOR_HPP* = 1
    template `max=`*(x,y:typed):void = x = max(x,y)
    template `>?=`*(x,y:typed):void = x.max= y
    template `min=`*(x,y:typed):void = x = min(x,y)
    template `<?=`*(x,y:typed):void = x.min= y
    discard
  when not declared ATCODER_INF_HPP:
    const ATCODER_INF_HPP* = 1
    template inf*(T): untyped = 
      when T is SomeFloat: T(Inf)
      elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
      else:
        static: assert(false)
    discard
  when not declared ATCODER_CHAEMON_WARLUS_OPERATOR_HPP:
    const ATCODER_CHAEMON_WARLUS_OPERATOR_HPP* = 1
    import strformat
    import macros
    proc discardableId*[T](x: T): T {.discardable.} = x
  
    macro `:=`*(x, y: untyped): untyped =
      var strBody = ""
      if x.kind == nnkPar:
        for i,xi in x:
          strBody &= fmt"""{'\n'}{xi.repr} := {y[i].repr}{'\n'}"""
      else:
        strBody &= fmt"""{'\n'}when declaredInScope({x.repr}):{'\n'}  {x.repr} = {y.repr}{'\n'}else:{'\n'}  var {x.repr} = {y.repr}{'\n'}"""
      strBody &= fmt"discardableId({x.repr})"
      parseStmt(strBody)
    discard
  when not declared ATCODER_SEQ_ARRAY_UTILS:
    const ATCODER_SEQ_ARRAY_UTILS* = 1
    import strformat
    import macros
    template makeSeq*(x:int; init):auto =
      when init is typedesc: newSeq[init](x)
      else: newSeqWith(x, init)
    macro Seq*(lens: varargs[int]; init):untyped =
      var a = fmt"{init.repr}"
      for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
      parseStmt(fmt"""  
  block:
    {a}""")
  
    template makeArray*(x:int; init):auto =
      var v:array[x, init.type]
      when init isnot typedesc:
        for a in v.mitems: a = init
      v
  
    macro Array*(lens: varargs[typed], init):untyped =
      var a = fmt"{init.repr}"
      for i in countdown(lens.len - 1, 0):
        a = fmt"makeArray({lens[i].repr}, {a})"
      parseStmt(fmt"""
  block:
    {a}""")
    discard
  when not declared ATCODER_DEBUG_HPP:
    const ATCODER_DEBUG_HPP* = 1
    import macros
    import strformat
    import terminal
    
    macro debug*(n: varargs[untyped]): untyped =
    #  var a = "stderr.write "
      var a = ""
      a.add "setForegroundColor fgYellow\n"
      a.add "echo "
      for i,x in n:
        a = a & fmt""" "{x.repr} = ", {x.repr} """
        if i < n.len - 1:
          a.add(""", ", ",""")
      a.add "\n"
      a.add "resetAttributes()"
      parseStmt(a)
    discard
when not declared ATCODER_SET_MAP_HPP:
  const ATCODER_SET_MAP_HPP* = 1
  when not declared ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP:
    const ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP* = 1
    import std/sugar
    import std/random
    
    type RandomizedBinarySearchTree*[D,L,useP,updateData] = object of RootObj
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
    
    type Node*[D, L, updateData] = ref object
      cnt*:int
      l*,r*:Node[D, L, updateData]
      key*:D
      when updateData isnot void:
        sum*:D
      when L isnot void:
        lazy*:L
      id:int
  
    proc isUpdateData*(t:typedesc[RandomizedBinarySearchTree] or typedesc[Node]):bool {.compileTime.} = t.updateData isnot void
    #proc hasData*(t:typedesc):bool {.compileTime.} = t.D isnot void
    proc hasLazy*(t:typedesc):bool {.compileTime.} = t.L isnot void
    proc hasP*(t:typedesc):bool {.compileTime.} = t.useP isnot void
    #proc isPersistent*(t:typedesc):bool {.compileTime.} = t.Persistent isnot void
  
  
    proc initNode*[RBST:RandomizedBinarySearchTree](self:RBST, k:RBST.D, p:RBST.L, id:int):auto =
      result = Node[RBST.D, RBST.L, RBST.updateData](cnt:1, key:k, lazy:p, l:nil, r:nil, id:id)
      when RBST.isUpdateData: result.sum = k
    proc initNode*[RBST:RandomizedBinarySearchTree](self:RBST, k:RBST.D, id:int):auto =
      result = Node[RBST.D, RBST.L, RBST.updateData](cnt:1, key:k, l:nil, r:nil, id:id)
      when RBST.isUpdateData: result.sum = k
    
    #vector< Node > pool;
    #int ptr;
    proc initRandomizedBinarySearchTree*[D](seed = 2019):auto =
      RandomizedBinarySearchTree[D,void,void,void](r:initRand(seed), id_max:0)
    proc initRandomizedBinarySearchTree*[D](f:(D,D)->D, D0:D, seed = 2019):auto =
      RandomizedBinarySearchTree[D,void,void,int](f:f, D0:D0, r:initRand(seed), id_max: 0)
    proc initRandomizedBinarySearchTree*[D,L](f:(D,D)->D, g:(D,L)->D, h:(L,L)->L, D0:D, L0:L, seed = 2019):auto =
      RandomizedBinarySearchTree[D,L,void,int](f:f, g:g, h:h, D0:D0, L0:L0, r:initRand(seed), id_max: 0)
    proc initRandomizedBinarySearchTree*[D, L](f:(D,D)->D, g:(D,L)->D, h:(L,L)->L, p:(L,Slice[int])->L,D0:D,L0:L,seed = 2019):auto =
      RandomizedBinarySearchTree[D,L,int,int](f:f, g:g, h:h, p:p, D0:D0, L0:L0, r:initRand(seed), id_max: 0)
    
    proc alloc*[RBST](self: var RBST, key:RBST.D):auto =
      when RBST.hasLazy:
        result = self.initNode(key, self.L0, self.id_max)
      else:
        result = self.initNode(key, self.id_max)
      self.id_max.inc
    #  return &(pool[ptr++] = Node(key, self.L0));
    
    template clone*[D,L,updateData](t:Node[D, L, updateData]):auto = t
    proc test*[RBST:RandomizedBinarySearchTree](self: var RBST, n, s:int):bool = 
      const randMax = 18_446_744_073_709_551_615u64
      let
        q = randMax div n.uint64
        qn = q * n.uint64
      while true:
        let x = self.r.next()
        if x < qn: return x < s.uint64 * q
    
    proc count*[RBST:RandomizedBinarySearchTree](self: RBST, t:Node):auto = (if t != nil: t.cnt else: 0)
    proc sum*[RBST:RandomizedBinarySearchTree](self: RBST, t:Node):auto = (if t != nil: t.sum else: self.D0)
    
    proc update*[RBST:RandomizedBinarySearchTree](self: RBST, t:var Node):Node {.inline.} =
      t.cnt = self.count(t.l) + self.count(t.r) + 1
      when RBST.isUpdateData:
        t.sum = self.f(self.f(self.sum(t.l), t.key), self.sum(t.r))
      t
    
    template propagate*[RBST:RandomizedBinarySearchTree](self: var RBST, t:Node):auto =
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
    
    proc merge*[RBST:RandomizedBinarySearchTree](self: var RBST, l, r:Node):auto =
      if l == nil: return r
      elif r == nil: return l
    #  when RBST.hasLazy:
      var (l, r) = (l, r)
  #    if self.r.rand(l.cnt + r.cnt - 1) < l.cnt:
      if self.test(l.cnt + r.cnt, l.cnt):
        when RBST.hasLazy:
          l = self.propagate(l)
        l.r = self.merge(l.r, r)
        return self.update(l)
      else:
        when RBST.hasLazy:
          r = self.propagate(r)
        r.l = self.merge(l, r.l)
        return self.update(r)
    
    proc split*[RBST:RandomizedBinarySearchTree](self:var RBST, t:Node, k:int):(Node, Node) =
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
    
    proc build*[RBST:RandomizedBinarySearchTree](self: var RBST, s:Slice[int], v:seq[RBST.D]):auto =
      let (l, r) = (s.a, s.b + 1)
      if l + 1 >= r: return self.alloc(v[l])
      var (x, y) = (self.build(l..<(l + r) shr 1, v), self.build((l + r) shr 1..<r, v))
      return self.merge(x, y)
    
    proc build*[RBST:RandomizedBinarySearchTree](self: var RBST, v:seq[RBST.D]):auto =
      return self.build(0..<v.len, v);
    #  ptr = 0;
    #  return build(0, (int) v.size(), v);
    
    proc to_vec*[RBST:RandomizedBinarySearchTree](self: var RBST, r:Node, v:var seq[RBST.D], i:var int) =
      if r == nil: return
      when RBST.hasLazy:
        var r = r
        r = self.propagate(r)
      self.to_vec(r.l, v, i)
      v[i] = r.key
      i.inc
    #  *it = r.key;
      self.to_vec(r.r, v, i);
    
    proc to_vec*[RBST:RandomizedBinarySearchTree](self: var RBST, r:Node):auto =
      result = newSeq[RBST.D](self.count(r))
      var i = 0
      self.to_vec(r, result, i)
    
    proc to_string*[RBST:RandomizedBinarySearchTree](self: var RBST, r:Node):string =
      return self.to_vec(r).join(", ")
    
    proc write_tree*[RBST:RandomizedBinarySearchTree](self: var RBST, r:Node, h = 0) =
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
    
    proc insert*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var Node, k:int, v:RBST.D) =
      var x = self.split(t, k)
      t = self.merge(self.merge(x[0], self.alloc(v)), x[1]);
    
    proc erase*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var Node, k:int) =
      var x = self.split(t, k)
      t = self.merge(x[0], self.split(x[1], 1)[1])
    
    proc query*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var Node, p:Slice[int]):auto =
      let (a, b) = (p.a, p.b + 1)
      var
        x = self.split(t, a)
        y = self.split(x[1], b - a)
      result = self.sum(y[0])
      var m = self.merge(y[0], y[1])
      t = self.merge(x[0], m)
    
    proc set_propagate*[RBST:RandomizedBinarySearchTree](self:var RBST, t:var Node, s:Slice[int], p:RBST.L) =
      static: assert RBST.hasLazy
      let (a, b) = (s.a, s.b + 1)
      var
        x = self.split(t, a)
        y = self.split(x[1], b - a)
      y[0].lazy = self.h(y[0].lazy, p)
      var m = self.merge(self.propagate(y[0]), y[1])
      t = self.merge(x[0], m)
    
    proc set_element*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var Node, k:int, x:RBST.D) =
      when RBST.hasLazy:
        t = self.propagate(t)
      if k < self.count(t.l): self.set_element(t.l, k, x)
      elif k == self.count(t.l):
        t.key = x
        t.sum = x
      else: self.set_element(t.r, k - self.count(t.l) - 1, x)
      t = self.update(t)
    
    proc len*[RBST:RandomizedBinarySearchTree](self: var RBST, t:Node):auto = self.count(t)
    proc empty*[RBST:RandomizedBinarySearchTree](self: var RBST, t:Node):bool = return t == nil
    proc makeset*[RBST:RandomizedBinarySearchTree](self: var RBST):Node[RBST.D, RBST.L, RBST.updateData] = nil 
    discard
  type SortedMultiSet*[K, T] = object
    rbst: RandomizedBinarySearchTree[K,void,void,void]
    root: Node[K, void, void]
  type SortedSet*[K, T] = object
    rbst: RandomizedBinarySearchTree[K,void,void,void]
    root: Node[K, void, void]
  type SortedMultiMap*[K, T] = object
    rbst: RandomizedBinarySearchTree[T,void,void,void]
    root: Node[T, void, void]
  type SortedMap*[K, T] = object
    rbst: RandomizedBinarySearchTree[T,void,void,void]
    root: Node[T, void, void]

  type anySet = SortedSet or SortedMultiSet
  type anyMap = SortedMap or SortedMultiMap

  type SetOrMap = SortedMultiSet or SortedSet or SortedMultiMap or SortedMap

  template getType*(T:typedesc[anySet], K):typedesc =
    T[K, K]
  template getType*(T:typedesc[anyMap], K, V):typedesc =
    T[K, (K, V)]

  proc init*(T:typedesc[SetOrMap]):T =
    result.rbst = initRandomizedBinarySearchTree[T.T]()
    result.root = nil

  proc initSortedMultiSet*[K]():auto = SortedMultiSet.getType(K).init()
  proc initSortedSet*[K]():auto = SortedSet.getType(K).init()
  proc initSortedMultiMap*[K, V]():auto = SortedMultiMap.getType(K, V).init()
  proc initSortedMap*[K, V]():auto = SortedMap.getType(K, V).init()

  #RBST(sz, [&](T x, T y) { return x; }, T()) {}
  
  template getKey*(self: SetOrMap, t:Node):auto =
    when self.type is anySet: t.key
    else: t.key[0]
  
  proc lower_bound*[T:SetOrMap](self: var T, t:var Node, x:T.K):int {.inline.}=
    if t == nil: return 0
    if x <= self.getKey(t): return self.lower_bound(t.l, x)
    return self.lower_bound(t.r, x) + self.rbst.count(t.l) + 1
  
  proc lower_bound*[T:SetOrMap](self:var T, x:T.K):int {.inline.} =
    self.lower_bound(self.root, x)

  proc upper_bound*[T:SetOrMap](self: var T, t:var Node, x:T.K):int {.inline.} =
    if t == nil: return 0
    if x < self.getKey(t): return self.upper_bound(t.l, x)
    return self.upper_bound(t.r, x) + self.rbst.count(t.l) + 1
  
  proc find*[T:SetOrMap](self: var T, t:var Node, x:T.K):Node {.inline.}=
    if t == nil: return nil
    if x < self.getKey(t): return self.find(t.l, x)
    elif x > self.getKey(t): return self.find(t.r, x)
    else: return t
  proc find*[T:SetOrMap](self:var T, x:T.K):auto {.inline.} =
    self.find(self.root, x)
  
  proc contains*[T:SetOrMap](self: var T, x:T.K):bool {.inline.} =
    self.find(x) != nil
  
  proc upper_bound*[T:SetOrMap](self: var T, x:T.K):int {.inline.} =
    self.upper_bound(self.root, x)
  
  proc kth_element*[T:SetOrmap](self: var T, t:Node, k:int):T.T {.inline.} =
    let p = self.rbst.count(t.l)
    if k < p: return self.kth_element(t.l, k)
    elif k > p: return self.kth_element(t.r, k - self.rbst.count(t.l) - 1)
    else: return t.key
  
  proc kth_element*[T:SetOrMap](self: var T, k:int):T.T {.inline.} =
    return self.kth_element(self.root, k)
  
  proc insert*[T:SortedMultiSet](self: var T, x:T.K) {.inline.} =
    self.rbst.insert(self.root, self.lower_bound(x), x)
  proc insert*[T:SortedMultiMap](self: var T, x:T.T) =
    self.rbst.insert(self.root, self.lower_bound(x[0]), x)
  
  proc count*[T:SetOrMap](self: var T, x:T.K):int {.inline.} =
    return self.upper_bound(x) - self.lower_bound(x)
  
  proc erase_key*[T:SetOrMap](self: var T, x:T.K) {.inline.} =
    if self.count(x) == 0: return
    self.rbst.erase(self.root, self.lower_bound(x))
  
  proc insert*[T:SortedSet](self: var T, x:T.K) {.inline.} =
    var t = self.find(x)
    if t != nil: return
    self.rbst.insert(self.root, self.lower_bound(x), x)
  proc insert*[T:SortedMap](self: var T, x:T.T) {.inline.} =
    var t = self.find(x[0])
    if t != nil: t.key = x
    else: self.rbst.insert(self.root, self.lower_bound(x[0]), x)
  proc `[]`*[K, V](self: var SortedMap[K, tuple[K:K, V:V]], x:K):auto {.inline.} =
    var t = self.find(x)
    if t != nil: return t.key[1]
    result = V.default
    self.insert((x, result))
  proc `[]=`*[K, V](self: var SortedMap[K, tuple[K:K, V:V]], x:K, v:V) {.inline.} =
    var t = self.find(x)
    if t != nil:
      t.key[1] = v
      return
    self.insert((x, v))
  
  proc len*(self:var SetOrMap):int {.inline.} = self.rbst.len(self.root)
  proc empty*(self:var SetOrMap):bool {.inline.} = self.rbst.empty(self.root)

proc solve(N:int, a:seq[int]) =
  var v = newSeq[(int,int)]()
  for i in 0..<N:
    v.add((a[i], i))
  v.sort()
  var st = SortedSet.getType(int).init()
#  var st = initSortedSet[int]()

  var ans = 0
  for (a, i) in v:
    let j = st.lower_bound(i)
    var l, r:int
#    debug j
    if j == st.len:
      r = N - 1
    else:
      r = st.kth_element(j) - 1
    if j == 0:
      l = 0
    else:
      l = st.kth_element(j - 1) + 1
#    echo l, " ", r, " ", i, " ", a
#    echo (i - l + 1) * (r - i + 1)
    ans += (i - l + 1) * (r - i + 1) * a
    st.insert(i)
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, a);
  return

main()
#}}}
