#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
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

# set library {{{
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
proc max*[T](self:SomeSet[T]):T = (var e = self.`end`();--e; *e)
proc contains*[T](self:SomeSet[T],x:T):bool = self.find(x) != self.`end`()
iterator items*[T](self:SomeSet[T]) : T =
  var (a,b) = (self.begin(),self.`end`())
  while a != b : yield *a; ++a
proc `>`*[T](self:SomeSet[T],x:T) : seq[T] =
  var (a,b) = (self.upper_bound(x),self.`end`())
  result = @[]; while a != b :result .add *a; ++a
proc `>=`*[T](self:SomeSet[T],x:T) : seq[T] =
  var (a,b) = (self.lower_bound(x),self.`end`())
  result = @[]; while a != b :result .add *a; ++a
proc toSet*[T](arr:seq[T]): SomeSet[T] = (result = initSet[T]();for a in arr: result.add(a))
proc toSeq[T](self:SomeSet[T]):seq[T] = self.mapIt(it)
proc `$`*[T](self:SomeSet[T]): string = $self.mapIt(it)
#}}}

let YES = "Yes"
let NO = "No"

#{{{ main function
proc main() =
  let
    N = nextInt()
    M = (1 shl N)
  var S = initMultiSet[int]()
  var ct = 0
  ct += 1
  for i in 0..<M:
    S.insert(nextInt())
    ct += 1
  var
    parent = newSeq[int]()
  var it = S.End
  --it
  parent.add(*it)
#  S.remove(S.tail.pred)
  for i in 0..<N:
#    assert S.End == S.tail
    var child = newSeq[int]()
    for p in parent:
      var it = S.lowerBound(p)
      if it == S.Begin:
        echo NO
        return
      --it
#      it = it.pred
      child.add(*it)
      S.erase(it)
    for c in child: parent.add(c)
  echo YES
  return

main()
#}}}
