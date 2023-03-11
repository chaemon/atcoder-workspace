#{{{ header
{.hints:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}
 
# set library {{{
type CSet {.importcpp: "std::set", header: "<set>".} [T] = object
type CSetIter {.importcpp: "std::set<'0>::iterator", header: "<set>".} [T] = object
proc cInitSet(T: typedesc): CSet[T] {.importcpp: "std::set<'*1>()", nodecl.}
proc initSet*[T](): CSet[T] = cInitSet(T)
proc insert*[T](self: var CSet[T],x:T) {.importcpp: "#.insert(@)", nodecl.}
proc empty*[T](self: CSet[T]):bool {.importcpp: "#.empty()", nodecl.}
proc size*[T](self: CSet[T]):int {.importcpp: "#.size()", nodecl.}
proc clear*[T](self:var CSet[T]) {.importcpp: "#.clear()", nodecl.}
proc erase*[T](self: var CSet[T],x:T) {.importcpp: "#.erase(@)", nodecl.}
proc find*[T](self: CSet[T],x:T): CSetIter[T] {.importcpp: "#.find(#)", nodecl.}
proc lowerBound*[T](self: CSet[T],x:T): CSetIter[T] {.importcpp: "#.lower_bound(#)", nodecl.}
proc upperBound*[T](self: CSet[T],x:T): CSetIter[T] {.importcpp: "#.upper_bound(#)", nodecl.}
proc Begin*[T](self:CSet[T]):CSetIter[T]{.importcpp: "#.begin()", nodecl.}
proc End*[T](self:CSet[T]):CSetIter[T]{.importcpp: "#.end()", nodecl.}
proc `*`*[T](self: CSetIter[T]):T{.importcpp: "*#", nodecl.}
proc `++`*[T](self:var CSetIter[T]){.importcpp: "++#", nodecl.}
proc `--`*[T](self:var CSetIter[T]){.importcpp: "--#", nodecl.}
proc `==`*[T](x,y:CSetIter[T]):bool{.importcpp: "(#==#)", nodecl.}
proc `==`*[T](x,y:CSet[T]):bool{.importcpp: "(#==#)", nodecl.}
proc distance*[T](x,y:CSetIter[T]):int{.importcpp: "distance(#,#)", nodecl.}
import sequtils # nim alias
proc add*[T](self:var CSet[T],x:T) = self.insert(x)
proc len*[T](self:CSet[T]):int = self.size()
proc min*[T](self:CSet[T]):T = *self.begin()
proc max*[T](self:CSet[T]):T = (var e = self.`end`();--e; *e)
proc contains*[T](self:CSet[T],x:T):bool = self.find(x) != self.`end`()
iterator items*[T](self:CSet[T]) : T =
  var (a,b) = (self.begin(),self.`end`())
  while a != b : yield *a; ++a
proc `>`*[T](self:CSet[T],x:T) : seq[T] =
  var (a,b) = (self.upper_bound(x),self.`end`())
  result = @[]; while a != b :result .add *a; ++a
proc `>=`*[T](self:CSet[T],x:T) : seq[T] =
  var (a,b) = (self.lower_bound(x),self.`end`())
  result = @[]; while a != b :result .add *a; ++a
proc toSet*[T](arr:seq[T]): CSet[T] = (result = initSet[T]();for a in arr: result.add(a))
proc toSeq[T](self:CSet[T]):seq[T] = self.mapIt(it)
proc `$`*[T](self:CSet[T]): string = $self.mapIt(it)
#}}}
 
#when isMainModule:
#  import unittest,sequtils
#  test "C++ set":
#    var s = @[3,1,4,1,5,9,2,6,5,3,5].toSet()
#    check: 8 notin s
#    check: s.min() == 1
#    check: s.max() == 9
#    check: s.len == 7
#    check: s > 4 == @[5, 6, 9]
#    check: s >= 4 == @[4, 5, 6, 9]
#    s.erase(s.max())
#    check: s.max() == 6
#    for _ in 0..<10: s.erase(1)
#    check: s.min() == 2
 
proc solve(N:int, P:seq[int]) =
  var v = newSeq[(int,int)]()
  for i in 0..<N:
    v.add((P[i],i))
  v.sort(cmp[(int,int)])
  v.reverse()
  var rbt = initSet[int]()
  var ans = 0
  for p in v:
    let i = p[1]
    var t = rbt.lowerBound(i)
    if rbt.len > 0:
      if t != rbt.End():
        var
          u = t
          v = t
          left = -1
          right = N
        --u;++v
        if u != rbt.End: left = *u
        if v != rbt.End(): right = *v
        ans += (right - *t) * (i - left) * p[0]
      --t
      if t != rbt.End():
        var
          u = t
          v = t
          left = -1
          right = N
        --u;++v
        if u != rbt.End(): left = *u
        if v != rbt.End(): right = *v
        ans += (*t - left) * (right - i) * p[0]
    rbt.insert(i)
  echo ans
 
#{{{ main function
proc main() =
  {.hints:off}
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
  var N = 0
  N = nextInt()
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
  solve(N, P);
  return
 
main()
#}}}
