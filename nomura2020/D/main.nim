#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
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

template SeqImpl(lens: seq[int]; init; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val
  discard

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 1, lens.len).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 1, lens.len)
    ArrayFill(a, init)
    a
#}}}

const MOD = 1000000007
var N:int
var P:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  P = newSeqWith(N, nextInt())
#}}}

#{{{ ModInt[Mod]

type ModInt[Mod: static[int]] = object
  v:int32

proc initModInt[T](a:T, Mod:static[int]):ModInt[Mod] =
  when T is ModInt:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    return ModInt[Mod](v:a.int32)

#proc init[Mod: static[int], T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity[Mod: static[int]](self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[Mod: static[int],T](a:ModInt[Mod], b:T):bool = a.v == initModInt(b, Mod).v
proc `!=`[Mod: static[int],T](a:ModInt[Mod], b:T):bool = a.v != initModInt(b, Mod).v
proc `-`[Mod: static[int]](self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:Mod - self.v)
proc `$`[Mod: static[int]](a:ModInt[Mod]):string = return $(a.v)

proc `+=`[Mod: static[int], T](self:var ModInt[Mod]; a:T) =
  self.v += initModInt(a, Mod).v
  if self.v >= Mod: self.v -= Mod
proc `-=`[Mod: static[int], T](self:var ModInt[Mod], a:T) =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += Mod
proc `*=`[Mod: static[int], T](self:var ModInt[Mod],a:T) =
  self.v = (self.v.int * initModInt(a, Mod).v.int mod Mod).int32
proc `^=`[Mod: static[int]](self:var ModInt[Mod], n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse[Mod:static[int]](self: ModInt[Mod]):ModInt[Mod] =
  var
    a = self.v.int
    b = Mod
    u = 1
    v = 0
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u, Mod)
proc `/=`[Mod: static[int], T](a:var ModInt[Mod],b:T):void =
  a *= initModInt(b, Mod).inverse()
proc `+`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = 
  result = a;result += b
proc `-`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result -= b
proc `*`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result *= b
proc `/`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a; result /= b
proc `^`[Mod: static[int]](a:ModInt[Mod],b:int):ModInt[Mod] = result = a; result ^= b
##}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)
converter toMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)
proc `$`(a:Mint):string = $(a.v)

#{{{ combination
import sequtils

proc `/`(a, b:int):int = a div b

proc fact(T:typedesc, k:int):T =
  var fact_a{.global.} = @[T(1)]
  if k >= fact_a.len:
    let sz_old = fact_a.len - 1
    let sz = max(sz_old * 2, k)
    fact_a.setlen(sz + 1)
    for i in sz_old + 1..sz: fact_a[i] = fact_a[i-1] * T(i)
  return fact_a[k]
proc rfact(T:typedesc, k:int):T =
  var rfact_a{.global.} = @[T(1)]
  if k >= rfact_a.len:
    let sz_old = rfact_a.len - 1
    let sz = max(sz_old * 2, k)
    rfact_a.setlen(sz + 1)
    rfact_a[sz] = T(1) / T.fact(sz)
    for i in countdown(sz - 1, sz_old + 1): rfact_a[i] = rfact_a[i + 1] * T(i + 1)
  return rfact_a[k]

proc inv(T:typedesc, k:int):T =
  return T.fact_a(k - 1) * T.rfact(k)

proc Permutation(T:typedesc, n,r:int):T =
  if r < 0 or n < r: return T(0)
  return T.fact(n) * T.rfact(n - r)
proc C(T:typedesc, p,q:int):T =
  if q < 0 or p < q: return T(0)
  return T.fact(p) * T.rfact(q) * T.rfact(p - q)
proc H(T: typedesc, n,r:int):T =
  if n < 0 or r < 0: return T(0)
  return if r == 0: T(1) else: T.C(n + r - 1, r)
#}}}

#{{{ Union-Find
type UnionFind = object
  data:seq[int]

proc initUnionFind(size:int):UnionFind =
  var uf:UnionFind
  uf.data = newSeqWith(size,-1)
  return uf

proc compress(uf:var UnionFind,x:int,r:var int):void =
  if uf.data[x]<0:
    r = x
    return
  uf.compress(uf.data[x],r)
  uf.data[x] = r;

proc root(uf:var UnionFind, x:int):int =
  var r:int
  uf.compress(x,r)
  return r;

proc size(uf:var UnionFind, x:int):int =
  return -uf.data[uf.root(x)]

proc unionSet(uf:var UnionFind, x,y:int):bool{.discardable.} =
  var
    rx = uf.root(x)
    ry = uf.root(y)
  if rx == ry: return false
  if uf.data[ry] < uf.data[rx]:
    swap(rx, ry)
  uf.data[rx] += uf.data[ry]
  uf.data[ry] = rx
  return true

proc findSet(uf:var UnionFind, x,y:int):bool =
  return uf.root(x) != uf.root(y)
#}}}

# {{{ dump
import macros

macro dump*(n: varargs[untyped]): untyped =
  result = newNimNode(nnkStmtList, n)
  for i,x in n:
    result.add(newCall("write", newIdentNode("stderr"), toStrLit(x)))
    result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(" = ")))
    result.add(newCall("write", newIdentNode("stderr"), x))
    if i < n.len - 1: result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(", ")))
  result.add(newCall("write", newIdentNode("stderr"), newStrLitNode("\n")))
# }}}

# enumerate_digits {{{
proc nextDigits(a:var seq[int], d:seq[int]):bool =
  doAssert(a.len == d.len)
  for i in 0..<a.len:
    a[i].inc
    if a[i] < d[i]:
      return true
    doAssert(a[i] == d[i])
    a[i] = 0
    if i == a.len - 1: return false

proc nextDigits(a:var seq[int], d:int):bool =
  for i in 0..<a.len:
    a[i].inc
    if a[i] < d:
      return true
    doAssert(a[i] == d)
    a[i] = 0
    if i == a.len - 1: return false

iterator enumerateDigits(n, d:int):seq[int] =
  var
    a = newSeq[int](n)
  while true:
    yield a
    if not a.nextDigits(d):
      break
# }}}

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

proc main() =
  for i in 0..<N:
    if P[i] != -1: P[i].dec
  var m1s = newSeq[int]()
  for i,d in P:
    if d == -1: m1s.add(i)
  let K = P.count(-1)
  uf := initUnionFind(N)
  for i in 0..<N:
    if P[i] != -1:
      uf.unionSet(i, P[i])

  var
    ans = Mint(N - 1)^K * N
    tb = initTable[int,seq[int]]()
  for u in 0..<N:
    tb[uf.root(u)].add(u)
  var v = newSeq[int]()
  for r, a in tb:
    found := false
    for u in a:
      if P[u] == -1:
        found = true
    if found:
      v.add(a.len)
    else:
      ans -= Mint(N - 1)^K
  var dp = newSeq[Mint](v.len + 1)
  dp[0] = Mint(1)
  for i in 0..<v.len:
    dp2 := dp
    for c in 0..<v.len:
      dp2[c + 1] += dp[c] * v[i]
    swap(dp, dp2)
  for k in 2..v.len:
    ans -= dp[k] * Mint.fact(k - 1) * Mint(N - 1)^(v.len - k)
  # k = 1
  for t in v:
    ans -= (t - 1) * Mint(N - 1)^(v.len - 1)
  print ans
  return

main()
