#{{{ header
{.hints:off warnings:off optimization:speed.}
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
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: doAssert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

# set and multiset library from C++ {{{
type CSet {.importcpp: "std::set", header: "<set>".} [T] = object
type CSetIter {.importcpp: "std::set<'0>::iterator", header: "<set>".} [T] = object
proc cInitSet(T: typedesc): CSet[T] {.importcpp: "std::set<'*1>()", nodecl.}
proc initSet*[T](): CSet[T] = cInitSet(T)

type CMultiSet {.importcpp: "std::multiset", header: "<set>".} [T] = object
type CMultiSetIter {.importcpp: "std::multiset<'0>::iterator", header: "<set>".} [T] = object
proc cInitMultiSet(T: typedesc): CMultiSet[T] {.importcpp: "std::multiset<'*1>()", nodecl.}
proc initMultiSet*[T](): CMultiSet[T] = cInitMultiSet(T)

type
  SomeSet[T] = CSet[T]|CMultiSet[T]
  SomeSetIter[T] = CSetIter[T]|CMultiSetIter[T]

proc insert*[T](self: var SomeSet[T],x:T) {.importcpp: "#.insert(@)", nodecl.}
proc empty*[T](self: SomeSet[T]):bool {.importcpp: "#.empty()", nodecl.}
proc size*[T](self: SomeSet[T]):int {.importcpp: "#.size()", nodecl.}
proc clear*[T](self:var SomeSet[T]) {.importcpp: "#.clear()", nodecl.}
proc erase*[T](self: var SomeSet[T],x:T) {.importcpp: "#.erase(@)", nodecl.}
proc erase*[T](self: var SomeSet[T],x:SomeSetIter[T]) {.importcpp: "#.erase(@)", nodecl.}
proc find*[T](self: SomeSet[T],x:T): SomeSetIter[T] {.importcpp: "#.find(#)", nodecl.}
proc lowerBound*[T](self: CSet[T],x:T): CSetIter[T] {.importcpp: "#.lower_bound(#)", nodecl.}
proc lowerBound*[T](self: CMultiSet[T],x:T): CMultiSetIter[T] {.importcpp: "#.lower_bound(#)", nodecl.}
proc upperBound*[T](self: CSet[T],x:T): CSetIter[T] {.importcpp: "#.upper_bound(#)", nodecl.}
proc upperBound*[T](self: CMultiSet[T],x:T): CMultiSetIter[T] {.importcpp: "#.upper_bound(#)", nodecl.}
proc Begin*[T](self:CSet[T]):CSetIter[T]{.importcpp: "#.begin()", nodecl.}
proc Begin*[T](self:CMultiSet[T]):CMultiSetIter[T]{.importcpp: "#.begin()", nodecl.}
proc End*[T](self:CSet[T]):CSetIter[T]{.importcpp: "#.end()", nodecl.}
proc End*[T](self:CMultiSet[T]):CMultiSetIter[T]{.importcpp: "#.end()", nodecl.}
proc `*`*[T](self: SomeSetIter[T]):T{.importcpp: "*#", nodecl.}
proc `++`*[T](self:var SomeSetIter[T]){.importcpp: "++#", nodecl.}
proc `--`*[T](self:var SomeSetIter[T]){.importcpp: "--#", nodecl.}
proc `==`*[T](x,y:SomeSetIter[T]):bool{.importcpp: "(#==#)", nodecl.}
proc `==`*[T](x,y:SomeSet[T]):bool{.importcpp: "(#==#)", nodecl.}
proc distance*[T](x,y:SomeSetIter[T]):int{.importcpp: "distance(#,#)", nodecl.}
import sequtils # nim alias
proc add*[T](self:var SomeSet[T],x:T) = self.insert(x)
proc len*[T](self:SomeSet[T]):int = self.size()
proc min*[T](self:SomeSet[T]):T = *self.begin()
proc max*[T](self:SomeSet[T]):T = (var e = self.End();--e; *e)
proc contains*[T](self:SomeSet[T],x:T):bool = self.find(x) != self.End()
iterator items*[T](self:SomeSet[T]) : T =
  var (a,b) = (self.Begin(),self.End())
  while a != b : yield *a; ++a
proc `>`*[T](self:SomeSet[T],x:T) : seq[T] =
  var (a,b) = (self.upper_bound(x),self.End())
  result = @[]; while a != b :result .add *a; ++a
proc `>=`*[T](self:SomeSet[T],x:T) : seq[T] =
  var (a,b) = (self.lower_bound(x),self.End())
  result = @[]; while a != b :result .add *a; ++a
proc toSet*[T](arr:openArray[T]): CSet[T] = (result = initSet[T]();for a in arr: result.add(a))
proc toMultiSet*[T](arr:openArray[T]): CMultiSet[T] = (result = initMultiSet[T]();for a in arr: result.add(a))
proc toSeq[T](self:SomeSet[T]):seq[T] = self.mapIt(it)
proc `$`*[T](self:SomeSet[T]): string = $self.mapIt(it)
#}}}

var N:int
var a:seq[int]

proc solve() =
  tb := initTable[int,int]()
  for i in 0..<N: tb[a[i]] += 1
  rest := initSet[int]()
  for i in 0..<N: rest.insert(i)
  if N <= 5:
    ans := newSeq[int](N)
    for i in 0..<N: ans[i] = i
    while true:
      valid := true
      for i in 0..<N-1:
        if a[ans[i]] == ans[i+1]: valid = false
      if valid:
        for i in 0..<N:
          stdout.write(ans[i]+1)
          if i < N - 1:
            stdout.write(" ")
        echo ""
        return
      if not ans.nextPermutation(): break
    echo -1
    return
  ans := newSeqWith(N, -1)
  for i in 0..<N:
    if i == N - 4:
      doAssert(false)
      v := newSeq[int]()
      for p in rest.items:
        v.add(p)
      while true:
        valid := true
        if a[ans[i-1]] == v[0]: valid = false
        for j in 0..<v.len - 1:
          if a[v[j]] == v[j+1]: valid = false
        if valid:
          break
        if not v.nextPermutation(): doAssert(false)
      for j in i..<N:
        ans[j] = v[j - i]
      break
    doAssert(tb.len > 0)
    flag := false
    if tb.len <= 2:
      target := -1
      for k,v in tb:
        if v == rest.len - 1 and k in rest:
          target = k
          flag = true
          break
      if flag:
        ans[i] = target
        flag = true
        doAssert(i == 0 or a[ans[i-1]] != ans[i])
    if not flag:
      ct := 0
      for p in rest.items:
        if i > 0 and a[ans[i-1]] == p: continue
        ans[i] = p
        break
      doAssert(ans[i] != -1)
    rest.erase(ans[i])
    tb[ans[i]] -= 1
    if tb[ans[i]] == 0: tb.del(ans[i])
  for i in 0..<N:
    stdout.write(ans[i]+1)
    if i < N - 1:
      stdout.write(" ")
  echo ""
  return

#{{{ main function
proc main() =
  N = nextInt()
  a = newSeqWith(N, nextInt()-1)
  solve()
  return

main()
#}}}
