# header {{{
{.hints:off warnings:off optimization:speed experimental:"codeReordering".}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
import strformat
import sugar
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
  parseStmt(a)

template makeArray(x; init):auto =
  when init is typedesc:
    var v:array[x, init]
  else:
    var v:array[x, init.type]
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(a)
#}}}

const MOD = 1000000007
var N:int
var K:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

when not declared ATCODER_MODINT_HPP:
  const ATCODER_MODINT_HPP* = 1

  type
    StaticModInt*[M: static[int]] = distinct uint32
    DynamicModInt*[T: static[int]] = distinct uint32

  type ModInt* = StaticModInt or DynamicModInt

  proc isStaticModInt*(T:typedesc):bool = T is StaticModInt
  proc isDynamicModInt*(T:typedesc):bool = T is DynamicModInt
  proc isModInt*(T:typedesc):bool = T.isStaticModInt or T.isDynamicModInt
  proc isStatic*(T:typedesc[ModInt]):bool = T is StaticModInt

  when not declared ATCODER_INTERNAL_MATH_HPP:
    const ATCODER_INTERNAL_MATH_HPP* = 1
    import std/math
  
    # Fast moduler by barrett reduction
    # Reference: https:#en.wikipedia.org/wiki/Barrett_reduction
    # NOTE: reconsider after Ice Lake
    type Barrett* = object
      m*, im:uint
  
    # @param m `1 <= m`
    proc initBarrett*(m:uint):auto = Barrett(m:m, im:(0'u - 1'u) div m + 1)
  
    # @return m
    proc umod*(self: Barrett):uint =
      self.m
  
    {.emit: """
  inline unsigned long long calc_mul(const unsigned long long &a, const unsigned long long &b){
    return (unsigned long long)(((unsigned __int128)(a)*b) >> 64);
  }
  """.}
    proc calc_mul*(a,b:culonglong):culonglong {.importcpp: "calc_mul(#,#)", nodecl.}
    # @param a `0 <= a < m`
    # @param b `0 <= b < m`
    # @return `a * b % m`
    proc mul*(self: Barrett, a:uint, b:uint):uint =
      # [1] m = 1
      # a = b = im = 0, so okay
  
      # [2] m >= 2
      # im = ceil(2^64 / m)
      # -> im * m = 2^64 + r (0 <= r < m)
      # let z = a*b = c*m + d (0 <= c, d < m)
      # a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
      # c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
      # ((ab * im) >> 64) == c or c + 1
      let z = a * b
      #  #ifdef _MSC_VER
      #      unsigned long long x;
      #      _umul128(z, im, &x);
      #  #else
      ##TODO
      #      unsigned long long x =
      #        (unsigned long long)(((unsigned __int128)(z)*im) >> 64);
      #  #endif
      let x = calc_mul(z.culonglong, self.im.culonglong).uint
      var v = z - x * self.m
      if self.m <= v: v += self.m
      return v
  
    # @param n `0 <= n`
    # @param m `1 <= m`
    # @return `(x ** n) % m`
    proc pow_mod_constexpr*(x,n,m:int):int =
      if m == 1: return 0
      var
        r = 1
        y = floorMod(x, m)
        n = n
      while n != 0:
        if (n and 1) != 0: r = (r * y) mod m
        y = (y * y) mod m
        n = n shr 1
      return r.int
    
    # Reference:
    # M. Forisek and J. Jancina,
    # Fast Primality Testing for Integers That Fit into a Machine Word
    # @param n `0 <= n`
    proc is_prime_constexpr*(n:int):bool =
      if n <= 1: return false
      if n == 2 or n == 7 or n == 61: return true
      if n mod 2 == 0: return false
      var d = n - 1
      while d mod 2 == 0: d = d div 2
      for a in [2, 7, 61]:
        var
          t = d
          y = pow_mod_constexpr(a, t, n)
        while t != n - 1 and y != 1 and y != n - 1:
          y = y * y mod n
          t =  t shl 1
        if y != n - 1 and t mod 2 == 0:
          return false
      return true
    proc is_prime*[n:static[int]]():bool = is_prime_constexpr(n)
  #  
  #  # @param b `1 <= b`
  #  # @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
    proc inv_gcd*(a, b:int):(int,int) =
      var a = floorMod(a, b)
      if a == 0: return (b, 0)
    
      # Contracts:
      # [1] s - m0 * a = 0 (mod b)
      # [2] t - m1 * a = 0 (mod b)
      # [3] s * |m1| + t * |m0| <= b
      var
        s = b
        t = a
        m0 = 0
        m1 = 1
    
      while t != 0:
        var u = s div t
        s -= t * u;
        m0 -= m1 * u;  # |m1 * u| <= |m1| * s <= b
    
        # [3]:
        # (s - t * u) * |m1| + t * |m0 - m1 * u|
        # <= s * |m1| - t * u * |m1| + t * (|m0| + |m1| * u)
        # = s * |m1| + t * |m0| <= b
    
        var tmp = s
        s = t;t = tmp;
        tmp = m0;m0 = m1;m1 = tmp;
      # by [3]: |m0| <= b/g
      # by g != b: |m0| < b/g
      if m0 < 0: m0 += b div s
      return (s, m0)
  
    # Compile time primitive root
    # @param m must be prime
    # @return primitive root (and minimum in now)
    proc primitive_root_constexpr*(m:int):int =
      if m == 2: return 1
      if m == 167772161: return 3
      if m == 469762049: return 3
      if m == 754974721: return 11
      if m == 998244353: return 3
      var divs:array[20, int]
      divs[0] = 2
      var cnt = 1
      var x = (m - 1) div 2
      while x mod 2 == 0: x = x div 2
      var i = 3
      while i * i <= x:
        if x mod i == 0:
          divs[cnt] = i
          cnt.inc
          while x mod i == 0:
            x = x div i
        i += 2
      if x > 1:
        divs[cnt] = x
        cnt.inc
      var g = 2
      while true:
        var ok = true
        for i in 0..<cnt:
          if pow_mod_constexpr(g, (m - 1) div divs[i], m) == 1:
            ok = false
            break
        if ok: return g
        g.inc
    proc primitive_root*[m:static[int]]():auto =
      primitive_root_constexpr(m)
    discard

  proc getBarrett*[T:static[int]](t:typedesc[DynamicModInt[T]], set = false, M:SomeInteger = 0.uint32):ptr Barrett =
    var Barrett_of_DynamicModInt {.global.} = initBarrett(998244353.uint)
    return Barrett_of_DynamicModInt.addr
  proc getMod*[T:static[int]](t:typedesc[DynamicModInt[T]]):uint32 {.inline.} =
    (t.getBarrett)[].m.uint32
  proc setMod*[T:static[int]](t:typedesc[DynamicModInt[T]], M:SomeInteger){.used inline.} =
    (t.getBarrett)[] = initBarrett(M.uint)

  proc `$`*(m: ModInt): string {.inline.} =
    $m.int

  template umod*[T:ModInt](self: typedesc[T]):uint32 =
    when T is StaticModInt:
      T.M
    elif T is DynamicModInt:
      T.getMod()
    else:
      static: assert false
  template umod*[T:ModInt](self: T):uint32 = self.type.umod

  proc `mod`*[T:ModInt](self:typedesc[T]):int = T.umod.int
  proc `mod`*[T:ModInt](self:T):int = self.umod.int

  proc init*[T:ModInt](t:typedesc[T], v: SomeInteger or T): auto {.inline.} =
    when v is T: return v
    else:
      when v is SomeUnsignedInt:
        if v.uint < T.umod:
          return T(v.uint32)
        else:
          return T((v.uint mod T.umod.uint).uint32)
      else:
        var v = v.int
        if 0 <= v:
          if v < T.mod: return T(v.uint32)
          else: return T((v mod T.mod).uint32)
        else:
          v = v mod T.mod
          if v < 0: v += T.mod
          return T(v.uint32)
  template initModInt*(v: SomeInteger or ModInt; M: static[int] = 1_000_000_007): auto =
    StaticModInt[M].init(v)

# TODO
#  converter toModInt[M:static[int]](n:SomeInteger):StaticModInt[M] {.inline.} = initModInt(n, M)

#  proc initModIntRaw*(v: SomeInteger; M: static[int] = 1_000_000_007): auto {.inline.} =
#    ModInt[M](v.uint32)
  proc raw*[T:ModInt](t:typedesc[T], v:SomeInteger):auto = T(v)

  proc inv*[T:ModInt](v:T):T {.inline.} =
    var
      a = v.int
      b = T.mod
      u = 1
      v = 0
    while b > 0:
      let t = a div b
      a -= t * b;swap(a, b)
      u -= t * v;swap(u, v)
    return T.init(u)

  proc val*(m: ModInt): int {.inline.} =
    int(m)

  proc `-`*[T:ModInt](m: T): T {.inline.} =
    if int(m) == 0: return m
    else: return T(m.umod() - uint32(m))

  template generateDefinitions(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*[T:ModInt](l: T; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: SomeInteger; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: T; r: SomeInteger): auto {.inline.} =
      body

  proc `+=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) += T.init(n).uint32
    if uint32(m) >= T.umod: uint32(m) -= T.umod

  proc `-=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) -= T.init(n).uint32
    if uint32(m) >= T.umod: uint32(m) += T.umod

  proc `*=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    when T is StaticModInt:
      uint32(m) = (uint(m) * T.init(n).uint mod T.umod).uint32
    elif T is DynamicModInt:
      uint32(m) = T.getBarrett[].mul(uint(m), T.init(n).uint).uint32
    else:
      static: assert false

  proc `/=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) = (uint(m) * T.init(n).inv().uint mod T.umod).uint32

#  proc `==`*[T:ModInt](m: T; n: SomeInteger | T): bool {.inline.} =
#    int(m) == T.init(n).int

  generateDefinitions(`+`, m, n):
    result = T.init(m)
    result += n

  generateDefinitions(`-`, m, n):
    result = T.init(m)
    result -= n

  generateDefinitions(`*`, m, n):
    result = T.init(m)
    result *= n

  generateDefinitions(`/`, m, n):
    result = T.init(m)
    result /= n

  generateDefinitions(`==`, m, n):
    result = (T.init(m).int == T.init(n).int)

  proc inc*[T:ModInt](m: var T) {.inline.} =
    uint32(m).inc
    if m == T.umod:
      uint32(m) = 0

  proc dec*[T:ModInt](m: var T) {.inline.} =
    if m == 0:
      uint32(m) = T.umod - 1
    else:
      uint32(m).dec

  proc pow*[T:ModInt](m: T; p: SomeInteger): T {.inline.} =
    assert 0 <= p
    var
      p = p.int
      m = m
    uint32(result) = 1
    while p > 0:
      if (p and 1) == 1:
        result *= m
      m *= m
      p = p shr 1
  proc `^`*[T:ModInt](m: T; p: SomeInteger): T {.inline.} = m.pow(p)

  type modint998244353* = StaticModInt[998244353]
  type modint1000000007* = StaticModInt[1000000007]
  type modint* = DynamicModInt[-1]
when not declared ATCODER_REVERSE_SLICE_HPP:
  const ATCODER_REVERSE_SLICE_HPP* = 1
  type ReversedSlice[T] = distinct Slice[T]
  
  proc reversed*[T](p:Slice[T]):auto = ReversedSlice[T](p)
  
  iterator items*[T](p:ReversedSlice[T]):T =
    var i = Slice[T](p).b
    while true:
      yield i
      if i == Slice[T](p).a:break
      i.dec

type mint = modint1000000007

proc main() =
  if N == K:
    var p = mint(1)
    for i in 0..<N:p *= A[i]
    echo p;return
  var A = A
  A.sort() do (a, b:int)->int:
    -cmp[int](a.abs, b.abs)
  block:
    var neg_ct = 0
    for i in 0..<N:
      if A[i] < 0: neg_ct.inc
    if neg_ct == N and K mod 2 == 1:
      var p = mint(1)
      for i in 0..<K:
        p *= A[N - 1 - i]
      echo p
      return
  var
    p = mint(1)
    neg_ct = 0
  for i in 0..<K:
    if A[i] < 0: neg_ct.inc
    p *= mint(A[i].abs)
  if neg_ct mod 2 == 0: echo p;return
  var i0, j0, i1, j1 = -1
  # remove neg, add pos
  for i in reversed(0..<K):
    if A[i] < 0:
      i0 = i
      break
  for i in K..<N:
    if A[i] >= 0:
      j0 = i
      break
  for i in reversed(0..<K):
    if A[i] >= 0:
      i1 = i
      break
  for i in K..<N:
    if A[i] < 0:
      j1 = i
      break
  var f0, f1 = true
  if i0 == -1 or j0 == -1: f0 = false
  if i1 == -1 or j1 == -1: f1 = false
  if f0 and not f1:
    echo p / A[i0].abs * A[j0].abs;return
  if f1 and not f0:
    echo p / A[i1].abs * A[j1].abs;return
  if f0 and f1:
    if A[j0].abs * A[i1].abs >= A[j1].abs * A[i0].abs:
      echo p / A[i0].abs * A[j0].abs
    else:
      echo p / A[i1].abs * A[j1].abs
    return
  # not f0 and not f1
  doAssert(false)
  return

main()

