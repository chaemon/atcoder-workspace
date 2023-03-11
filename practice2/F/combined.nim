# header {{{
{.hints:off checks:off warnings:off assertions:on optimization:speed.}
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

const MOD = 998244353
var N:int
var M:int
var a:seq[int]
var b:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(N-1-0+1, nextInt())
  b = newSeqWith(M-1-0+1, nextInt())
#}}}

when not defined ATCODER_MODINT_HPP:
  const ATCODER_MODINT_HPP* = 1

  type
    StaticModInt*[M: static[int]] = distinct uint32
  type
    DynamicModInt* = distinct uint32
  
  type ModInt = StaticModInt or DynamicModInt

  proc getMod(t:typedesc[DynamicModInt], set = false, M:SomeInteger = 0.uint32):uint32 =
    var ModVal{.global.} = 1000000007.uint32
    if set: ModVal = M.uint32
    return ModVal
  proc setMod(t:typedesc[DynamicModInt], M:SomeInteger){.used.} =
    discard t.getMod(true, M)

  proc `$`*(m: ModInt): string {.inline.} =
    $m.int

  template umod[T:ModInt](self: typedesc[T]):uint32 =
    when T is StaticModInt:
      T.M
    elif T is DynamicModInt:
      T.getMod()
    else:
      static: assert false
  template umod[T:ModInt](self: T):uint32 = self.type.umod

#  proc initModInt*(v: SomeInteger or ModInt; M: static[int] = 1_000_000_007): auto {.inline.} =
#    when v is ModInt: return v
#    else:
#      if 0 <= v:
#        if v < M: return ModInt[M](v.uint32)
#        else: return ModInt[M]((v mod M).uint32)
#      else:
#        var v = v mod M
#        if v < 0: v += M
#        return ModInt[M](v.uint32)
  proc init*[T:ModInt](t:typedesc[T], v: SomeInteger or T): auto {.inline.} =
    when v is T: return v
    else:
      var v = v.int
      if 0 <= v:
        if v < T.umod.int: return T(v.uint32)
        else: return T((v mod T.umod.int).uint32)
      else:
        v = v mod T.umod.int
        if v < 0: v += T.umod.int
        return T(v.uint32)

#  converter toModInt[M:static[int]](n:SomeInteger):ModInt[M] {.inline.}= initModInt(n, M)

  proc initModIntRaw*(v: SomeInteger; M: static[int] = 1_000_000_007): auto {.inline.} =
    ModInt[M](v.uint32)

  proc inv[T](v:T):T {.inline.} =
    var
      a = T.init(v).int
      b = T.umod.int
      u = 1
      v = 0
    while b > 0:
      let t = a div b
      a -= t * b;swap(a, b)
      u -= t * v;swap(u, v)
    return T.init(u)

#  proc retake*[M: static[int]](m: var ModInt[M]) {.inline.} =
#    int(m) = int(m).modulo(M)

  proc val*(m: ModInt): int {.inline.} =
    int(m)

#  proc modulo*[M: static](m: ModInt): int {.inline.} =
#    M

  proc `-`*(m: ModInt): ModInt {.inline.} =
    if int(m) == 0: return m
    else: return m.type(m.umod() - int(m))

  template generateDefinitions(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*[T:ModInt](l: T; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: SomeInteger; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: T; r: SomeInteger): auto {.inline.} =
      body

#  proc inv*[M: static[int]](m: ModInt[M]): ModInt[M] {.inline.} =
#    result = initModInt(extgcd(M, int(m))[1], M)

  proc `+=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) += T.init(n).uint32
    if uint32(m) >= T.umod: uint32(m) -= T.umod

  proc `-=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) += T.umod - T.init(n).uint32
    if uint32(m) >= T.umod: uint32(m) -= T.umod

  proc `*=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) = (uint(m) * T.init(n).uint mod T.umod()).uint32
#    m.retake()

  proc `/=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) = (uint(m) * T.init(n).inv().uint mod T.umod).uint32
#    m.retake()

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

  proc `==`*[T:ModInt](m: T; n: SomeInteger | T): bool {.inline.} =
    int(m) == T.init(n).int

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
    var
      p = p.int
      m = m
    uint32(result) = 1
    while p > 0:
      if (p and 1) == 1:
        result *= m
      m *= m
      p = p shr 1

#type mint = StaticModInt[13]
#var a = mint(10)
#echo a + a
#type dmint = DynamicModInt
#dmint.setMod(19)
#var b = dmint(17)
#echo b + b
#
  discard
when not declared ATCODER_CONVOLUTION_HPP:
  const ATCODER_CONVOLUTION_HPP = 1

#include <algorithm>
#include <array>
#include <atcoder/internal_bit>
#include <atcoder/modint>
#include <cassert>
#include <type_traits>
#include <vector>
  import math
  when not declared ATCODER_INTERNAL_MATH_HPP:
    const ATCODER_INTERNAL_MATH_HPP* = 1
    import math
  
    # Fast moduler by barrett reduction
    # Reference: https:#en.wikipedia.org/wiki/Barrett_reduction
    # NOTE: reconsider after Ice Lake
    type barrett* = object
      m, im:uint
  
    # @param m `1 <= m`
    proc initBarrett*(m:uint):auto = barrett(m:m, im:(0'u - 1'u) div m + 1)
  
    # @return m
    proc umod*(self: barrett):uint =
      self.m
  
    # @param a `0 <= a < m`
    # @param b `0 <= b < m`
    # @return `a * b % m`
    proc mul*(self: barrett, a:uint, b:uint):uint =
      # [1] m = 1
      # a = b = im = 0, so okay
  
      # [2] m >= 2
      # im = ceil(2^64 / m)
      # -> im * m = 2^64 + r (0 <= r < m)
      # let z = a*b = c*m + d (0 <= c, d < m)
      # a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
      # c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
      # ((ab * im) >> 64) == c or c + 1
      var z = a
      z *= b
    #  #ifdef _MSC_VER
    #      unsigned long long x;
    #      _umul128(z, im, &x);
    #  #else
    ##TODO
    #      unsigned long long x =
    #        (unsigned long long)(((unsigned __int128)(z)*im) >> 64);
    #  #endif
    #  var v = z - x * self.m
    #  if self.m <= v: v += self.m
    #  return v
  
    # @param n `0 <= n`
    # @param m `1 <= m`
    # @return `(x ** n) % m`
    proc pow_mod_constexpr(x,n,m:int):int {.compileTime.} =
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
    proc is_prime_constexpr(n:int):bool {.compileTime.} =
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
    proc is_prime*[n:static[int]]():bool {.compileTime.} = is_prime_constexpr(n)
  #  
  #  # @param b `1 <= b`
  #  # @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
    proc inv_gcd*(a, b:int):(int,int) {.compileTime} =
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
    proc primitive_root_constexpr(m:int):int {.compileTime.} =
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
    proc primitive_root*[m:static[int]]():auto {.compileTime.} =
      primitive_root_constexpr(m)
  
    discard
  when not declared ATCODER_INTERNAL_BITOP_HPP:
    const ATCODER_INTERNAL_BITOP_HPP* = 1
    import bitops
  
  #ifdef _MSC_VER
  #include <intrin.h>
  #endif
  
  # @param n `0 <= n`
  # @return minimum non-negative `x` s.t. `n <= 2**x`
    proc ceil_pow2*(n:int):int =
      var x = 0
      while (1'u shl x) < n.uint: x.inc
      return x
  # @param n `1 <= n`
  # @return minimum non-negative `x` s.t. `(n & (1 << x)) != 0`
    proc bsf*(n:uint):int =
      return countTrailingZeroBits(n)
    discard
  
#  template <class mint, internal::is_static_modint_t<mint>* = nullptr>
  proc butterfly*[mint:StaticModInt](a:var seq[mint]) =
    const g = primitive_root[mint.M]()
    let
      n = a.len
      h = ceil_pow2(n)
    
    var 
      first {.global.} = true
      sum_e {.global.} :array[30, mint]   # sum_e[i] = ies[0] * ... * ies[i - 1] * es[i]
    if first:
      first = false
      var es, ies:array[30, mint] # es[i]^(2^(2+i)) == 1
      let cnt2 = bsf(mint.M - 1)
      var
        e = mint(g).pow((mint.M - 1) shr cnt2)
        ie = e.inv()
      for i in countdown(cnt2, 2):
        # e^(2^i) == 1
        es[i - 2] = e
        ies[i - 2] = ie
        e *= e
        ie *= ie
      var now = mint(1)
      for i in 0..<cnt2 - 2:
        sum_e[i] = es[i] * now
        now *= ies[i]
    for ph in 1..h:
      let
        w = 1 shl (ph - 1)
        p = 1 shl (h - ph)
      var now = mint(1)
      for s in 0..<w:
        let offset = s shl (h - ph + 1)
        for i in 0..<p:
          let
            l = a[i + offset]
            r = a[i + offset + p] * now
          a[i + offset] = l + r
          a[i + offset + p] = l - r
        now *= sum_e[bsf(not s.uint)]
  
  proc butterfly_inv*[mint:StaticModInt](a:var seq[mint]) =
    const g = primitive_root[mint.M]()
    let
      n = a.len
      h = ceil_pow2(n)
    var
      first{.global.} = true
      sum_ie{.global.}:array[30, mint]  # sum_ie[i] = es[0] * ... * es[i - 1] * ies[i]
    if first:
      first = false
      var es, ies: array[30, mint] # es[i]^(2^(2+i)) == 1
      let cnt2 = bsf(mint.M - 1)
      var
        e = mint(g).pow((mint.M - 1) shr cnt2)
        ie = e.inv()
      for i in countdown(cnt2, 2):
        # e^(2^i) == 1
        es[i - 2] = e
        ies[i - 2] = ie
        e *= e
        ie *= ie
      var now = mint(1)
      for i in 0..<cnt2 - 2:
        sum_ie[i] = ies[i] * now
        now *= es[i]
  
    for ph in countdown(h, 1):
      let
        w = 1 shl (ph - 1)
        p = 1 shl (h - ph)
      var inow = mint(1)
      for s in 0..<w:
        let offset = s shl (h - ph + 1)
        for i in 0..<p:
          let
            l = a[i + offset]
            r = a[i + offset + p]
          a[i + offset] = l + r
          a[i + offset + p] = mint.init((mint.umod.uint + l.uint - r.uint) * uint(inow))
        inow *= sum_ie[bsf(not s.uint)]

#  template <class mint, internal::is_static_modint_t<mint>* = nullptr>
  proc convolution*[mint:StaticModInt](a, b:seq[mint]):seq[mint] =
    var
      n = a.len
      m = b.len
    if n == 0 or m == 0: return newSeq[mint]()
    var (a, b) = (a, b)
    if min(n, m) <= 60:
      if n < m:
        swap(n, m)
        swap(a, b)
      var ans = newSeq[mint](n + m - 1)
      for i in 0..<n:
        for j in 0..<m:
          ans[i + j] += a[i] * b[j]
      return ans
    let z = 1 shl ceil_pow2(n + m - 1)
    a.setlen(z)
    butterfly(a)
    b.setlen(z)
    butterfly(b);
    for i in 0..<z:
      a[i] *= b[i]
    butterfly_inv(a)
    a.setlen(n + m - 1)
    let iz = mint(z).inv()
    for i in 0..<n+m-1: a[i] *= iz
    return a
  
#  template <unsigned int mod = 998244353,
#      class T,
#      std::enable_if_t<internal::is_integral<T>::value>* = nullptr>
  proc convolution*[M:static[uint] = 998244353, T:SomeInteger](a, b:seq[T]):seq[T] =
    let (n, m) = (a.len, b.len)
    if n == 0 or m == 0: return newSeq[T]()
  
    type mint = StaticModInt[M.int]
    var
      a2 = newSeq[mint](n)
      b2 = newSeq[mint](m)
    for i in 0..<n:
      a2[i] = mint(a[i])
    for i in 0..<m:
      b2[i] = mint(b[i])
#    let c2 = convolution(move(a2), move(b2))
    let c2 = convolution(a2, b2)
    var c = newSeq[T](n + m - 1)
    for i in 0..<n + m - 1:
      c[i] = c2[i].val()
    return c
  proc convolution_ll*(a, b:seq[int]):seq[int] =
    let (n, m) = (a.len, b.len)
    if n == 0 or m == 0: return newSeq[int]()
    const
      MOD1:uint = 754974721  # 2^24
      MOD2:uint = 167772161  # 2^25
      MOD3:uint = 469762049  # 2^26
      M2M3 = MOD2 * MOD3
      M1M3 = MOD1 * MOD3
      M1M2 = MOD1 * MOD2
      M1M2M3 = MOD1 * MOD2 * MOD3

      i1 = inv_gcd((MOD2 * MOD3).int, MOD1.int)[1].uint
      i2 = inv_gcd((MOD1 * MOD3).int, MOD2.int)[1].uint
      i3 = inv_gcd((MOD1 * MOD2).int, MOD3.int)[1].uint
    
    let
      c1 = convolution[MOD1,int](a, b)
      c2 = convolution[MOD2,int](a, b)
      c3 = convolution[MOD3,int](a, b)
  
    var c = newSeq[int](n + m - 1)
    for i in 0..<n + m - 1:
      var x = 0.uint
      x += (c1[i].uint * i1) mod MOD1 * M2M3
      x += (c2[i].uint * i2) mod MOD2 * M1M3
      x += (c3[i].uint * i3) mod MOD3 * M1M2
      # B = 2^63, -B <= x, r(real value) < B
      # (x, x - M, x - 2M, or x - 3M) = r (mod 2B)
      # r = c1[i] (mod MOD1)
      # focus on MOD1
      # r = x, x - M', x - 2M', x - 3M' (M' = M % 2^64) (mod 2B)
      # r = x,
      #   x - M' + (0 or 2B),
      #   x - 2M' + (0, 2B or 4B),
      #   x - 3M' + (0, 2B, 4B or 6B) (without mod!)
      # (r - x) = 0, (0)
      #       - M' + (0 or 2B), (1)
      #       -2M' + (0 or 2B or 4B), (2)
      #       -3M' + (0 or 2B or 4B or 6B) (3) (mod MOD1)
      # we checked that
      #   ((1) mod MOD1) mod 5 = 2
      #   ((2) mod MOD1) mod 5 = 3
      #   ((3) mod MOD1) mod 5 = 4
      var diff = c1[i] - floorMod(x.int, MOD1.int)
      if diff < 0: diff += MOD1.int
      const offset = [0'u, 0'u, M1M2M3, 2'u * M1M2M3, 3'u * M1M2M3]
      x -= offset[diff mod 5]
      c[i] = x.int
    return c
  discard

proc main() =
  echo convolution[MOD, int](a, b).join(" ")
  return

main()

