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
  else: assert(false)

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
var K:int
var R:int

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  R = nextInt()
#}}}

main()

proc check(A:seq[int]) =
  doAssert(A.len == N)
  s := initSet[int]()
  ans := 0
  for i,a in A:
    let d = distance(s.lowerBound(a + K), s.End)
    ans += d
    s.add(a)
  doAssert(ans == R)

proc main() =
  let t = N - K
  if R > t * (t + 1) div 2:
    echo "No Luck"
    return
  var A = newSeq[int]()
  for i in 0..<N:A.add(i+1)
  A.reverse()
  var
    r = 0
    s = t
  while s > 0:
    if R < r + s:
      var d = R - r
      A.reverse(0, N - 1 - (t - s))
      var i = 0
      while d > 0:
        swap(A[i], A[i + 1])
        if A[i] >= A[i + 1] + K: d -= 1
        i += 1
#      swap(A[0], A[d + K - 1])
      break
    r += s
    s -= 1
  for a in A:
    stdout.write a, " "
  echo ""
  check(A)
  return
