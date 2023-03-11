# {{{ header
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
  
  import streams
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
  
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  
  proc discardableId*[T](x: T): T {.discardable.} =
    return x
  
  macro `:=`*(x, y: untyped): untyped =
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
# }}}
when not declared ATCODER_MODINT_HPP:
  const ATCODER_MODINT_HPP* = 1

  type
    StaticModInt*[M: static[int]] = distinct uint32
  type
    DynamicModInt*[T: static[int]] = distinct uint32
  
  type ModInt* = StaticModInt or DynamicModInt

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
    proc pow_mod_constexpr*(x,n,m:int):int {.compileTime.} =
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
    proc is_prime_constexpr*(n:int):bool {.compileTime.} =
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
    proc primitive_root_constexpr*(m:int):int {.compileTime.} =
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

  proc getBarrett*[T:static[int]](t:typedesc[DynamicModInt[T]], set = false, M:SomeInteger = 0.uint32):ptr Barrett =
    var Barrett_of_DynamicModInt {.global.} :Barrett
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
  template initModInt*(v: SomeInteger or ModInt; M: static[int] = 1_000_000_007): auto =
    StaticModInt[M].init(v)

# TODO
#  converter toModInt[M:static[int]](n:SomeInteger):ModInt[M] {.inline.}= initModInt(n, M)

  proc initModIntRaw*(v: SomeInteger; M: static[int] = 1_000_000_007): auto {.inline.} =
    ModInt[M](v.uint32)

  proc inv*[T](v:T):T {.inline.} =
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
      uint32(m) = (uint(m) * T.init(n).uint mod T.umod()).uint32
    elif T is DynamicModInt:
      uint32(m) = T.getBarrett[].mul(uint(m), T.init(n).uint).uint32
    else:
      static: assert false

  proc `/=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    uint32(m) = (uint(m) * T.init(n).inv().uint mod T.umod).uint32

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

  type modint998244353* = StaticModInt[998244353]
  type modint1000000007* = StaticModInt[1000000007]
  type modint* = DynamicModInt[-1]

const MOD = 998244353
var N:int
var K:int
var L:seq[int]
var R:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  L = newSeqWith(K, 0)
  R = newSeqWith(K, 0)
  for i in 0..<K:
    L[i] = nextInt()
    R[i] = nextInt()
#}}}

# FormalPowerSeries {{{
when not declared ATCODER_FORMAL_POWER_SERIES:
  const ATCODER_FORMAL_POWER_SERIES* = 1
  
  import std/sequtils
  import std/strformat
  import std/options
  import std/macros
  import std/tables
  
  when not declared ATCODER_CONVOLUTION_HPP:
    const ATCODER_CONVOLUTION_HPP* = 1
  
  #include <algorithm>
  #include <array>
  #include <atcoder/internal_bit>
  #include <atcoder/modint>
  #include <cassert>
  #include <type_traits>
  #include <vector>
    import std/math
    when not declared ATCODER_INTERNAL_BITOP_HPP:
      const ATCODER_INTERNAL_BITOP_HPP* = 1
      import std/bitops
    
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
        for i in 0..cnt2 - 2:
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
      butterfly(b)
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
    proc convolution*[M:static[uint], T:SomeInteger](a, b:seq[T]):seq[T] =
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
#  import atcoder/extra/math/element_concepts
  when not declared ATCODER_INTERNAL_FFT_HPP:
    const ATCODER_INTERNAL_FFT_HPP* = 1
    when not declared ATCODER_PARTICULAR_MOD_CONVOLUTION:
      const ATCODER_PARTICULAR_MOD_CONVOLUTION* = 1
      import std/sequtils
      type ParticularModConvolution* = object
        discard
      proc fft*[T:StaticModInt](t:typedesc[ParticularModConvolution], a:seq[T]):seq[T] {.inline.} =
        result = a
        butterfly(result)
      proc dot*[T:StaticModInt](a, b:seq[T]):seq[T] =
        result = newSeq[T](a.len)
        for i in 0..<a.len:
          result[i] = a[i] * b[i]
      proc ifft*[T:StaticModInt](t:typedesc[ParticularModConvolution], a:seq[T]):seq[T] {.inline.} =
        result = a
        result.butterfly_inv
        let iz = T(a.len).inv()
        result.applyIt(it * iz)
      proc convolution*[T:StaticModInt](t:typedesc[ParticularModConvolution], a, b:seq[T]):auto {.inline.} = convolution(a, b)
      discard
    when not declared ATCODER_ARBITRARY_MOD_CONVOLUTION:
      const ATCODER_ARBITRARY_MOD_CONVOLUTION* = 1
    
      type ArbitraryModConvolution* = object
        discard
    
      const
        m0 = 167772161.uint
        m1 = 469762049.uint
        m2 = 754974721.uint
      type
        mint0 = StaticModInt[m0.int]
        mint1 = StaticModInt[m1.int]
        mint2 = StaticModint[m2.int]
    
      const
        r01 = mint1.init(m0).inv().uint
        r02 = mint2.init(m0).inv().uint
        r12 = mint2.init(m1).inv().uint
        r02r12 = r02 * r12 mod m2
    
      proc fft*[T:ModInt](t:typedesc[ArbitraryModConvolution], a:seq[T]):auto {.inline.} =
        type F = ParticularModConvolution
        var
          v0 = newSeq[mint0](a.len)
          v1 = newSeq[mint1](a.len)
          v2 = newSeq[mint2](a.len)
        for i in 0..<a.len:
          v0[i] = mint0.init(a[i].int)
          v1[i] = mint1.init(a[i].int)
          v2[i] = mint2.init(a[i].int)
        v0 = F.fft(v0)
        v1 = F.fft(v1)
        v2 = F.fft(v2)
        return (v0,v1,v2)
      proc dot*(a, b:(seq[mint0], seq[mint1], seq[mint2])):auto =
        let N = a[0].len
        result = (newSeq[mint0](N), newSeq[mint1](N), newSeq[mint2](N))
        for i in 0..<N:
          result[0][i] = a[0][i] * b[0][i]
          result[1][i] = a[1][i] * b[1][i]
          result[2][i] = a[2][i] * b[2][i]
      
      proc calc_garner[T:ModInt](a0:seq[mint0], a1:seq[mint1], a2:seq[mint2], deg:int):seq[T] =
        let
          w1 = m0 mod T.umod
          w2 = w1 * m1 mod T.umod
        result = newSeq[T](deg)
        for i in 0..<deg:
          let
            (n0, n1, n2) = (a0[i].uint, a1[i].uint, a2[i].uint)
            b = (n1 + m1 - n0) * r01 mod m1
            c = ((n2 + m2 - n0) * r02r12 + (m2 - b) * r12) mod m2
          result[i] = T.init(n0 + b * w1 + c * w2)
    
      proc ifft*[T:ModInt](t:typedesc[ArbitraryModConvolution], a:(seq[mint0], seq[mint1], seq[mint2]), deg = -1):auto {.inline.} =
        type F = ParticularModConvolution
        let
          deg = if deg == -1: a[0].len else: deg
          a0 = F.ifft(a[0])
          a1 = F.ifft(a[1])
          a2 = F.ifft(a[2])
        return calc_garner[T](a0, a1, a2, deg)
      proc convolution*[T:ModInt](t:typedesc[ArbitraryModConvolution], a, b:seq[T]):seq[T] {.inline.} =
        var
          a0 = newSeq[mint0](a.len)
          a1 = newSeq[mint1](a.len)
          a2 = newSeq[mint2](a.len)
        for i in 0..<a.len:
          a0[i] = mint0.init(a[i].int)
          a1[i] = mint1.init(a[i].int)
          a2[i] = mint2.init(a[i].int)
        var
          b0 = newSeq[mint0](b.len)
          b1 = newSeq[mint1](b.len)
          b2 = newSeq[mint2](b.len)
        for i in 0..<b.len:
          b0[i] = mint0.init(b[i].int)
          b1[i] = mint1.init(b[i].int)
          b2[i] = mint2.init(b[i].int)
        let
          c0 = convolution.convolution(a0, b0)
          c1 = convolution.convolution(a1, b1)
          c2 = convolution.convolution(a2, b2)
        return calc_garner[T](c0, c1, c2, a.len + b.len - 1)
      discard
  
    template get_fft_type*[T:ModInt](self: typedesc[T]):typedesc =
      when T is StaticModInt and (T.umod - 1) mod (1 shl 20) == 0: ParticularModConvolution
      else: ArbitraryModConvolution
  
    discard
#  import atcoder/extra/math/combination

  type FormalPowerSeries*[T:ModInt] = seq[T]
  type SparseFormalPowerSeries*[T:ModInt] = seq[(int, T)]

  proc initFormalPowerSeries*[T](n:int):FormalPowerSeries[T] =
    FormalPowerSeries[T](newSeq[T](n))
  proc initFormalPowerSeries*[T](v:seq or array):FormalPowerSeries[T] =
    when v is FormalPowerSeries[T]: return v
    else:
      result = newSeq[T](data.len)
      for i, it in data:
        result[i] = T.init(it)
  template init*[T](self:typedesc[FormalPowerSeries[T]], data:typed):auto =
    initFormalPowerSeries[T](data)

  macro revise(a, b) =
    parseStmt(fmt"""let {a.repr} = if {a.repr} == -1: {b.repr} else: {a.repr}""")
  # sqrt {{{
  type
    SQRT[T] = proc(t:T):Option[T]
  
  proc sqrtSub[T](self:FormalPowerSeries[T], update: bool, f:SQRT[T]):(bool, SQRT[T]){.discardable.} =
    var is_set{.global.} = false
    var sqr{.global.}:SQRT[T] = nil
    if update:
      is_set = true
      sqr = f
    return (is_set, sqr)
  proc isSetSqrt[T](self:FormalPowerSeries[T]):bool = return self.sqrtSub(false, nil)[0]
  proc setSqrt[T](self:FormalPowerSeries[T], f: SQRT[T]):SQRT[T]{.discardable.} = return self.sqrtSub(true, f)[1]
  proc getSqrt[T](self:FormalPowerSeries[T]):SQRT[T]{.discardable.} = return self.sqrtSub(false, nil)[1]
  #}}}
  
  proc shrink*[T](self: var FormalPowerSeries[T]) =
    while self.len > 0 and self[^1] == 0: discard self.pop()
 
  # operators +=, -=, *=, mod=, -, /= {{{
  proc `+=`*(self: var FormalPowerSeries, r:FormalPowerSeries) =
    if r.len > self.len: self.setlen(r.len)
    for i in 0..<r.len: self[i] += r[i]
  proc `+=`*[T](self: var FormalPowerSeries[T], r:T) =
    if self.len == 0: self.setlen(1)
    self[0] += r
  
  proc `-=`*[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) =
    if r.len > self.len: self.setlen(r.len)
    for i in 0..<r.len: self[i] -= r[i]
#    self.shrink()
  proc `-=`*[T](self: var FormalPowerSeries[T], r:T) =
    if self.len == 0: self.setlen(1)
    self[0] -= r
#    self.shrink()

  proc `*=`*[T](self: var FormalPowerSeries[T], v:T) = self.applyIt(it * v)

  proc multRaw*[T](a:FormalPowerSeries[T], b:SparseFormalPowerSeries[T], deg = -1):FormalPowerSeries[T] =
    var deg = deg
    if deg == -1:
      var bdeg = 0
      for p in b: bdeg = max(bdeg, p[0])
      deg = a.len + bdeg
    result = initFormalPowerSeries[T](deg)
    for i in 0..<a.len:
      for (j, c) in b:
        let k = i + j
        if k < deg: result[k] += a[i] * c
  proc multRaw*[T](a, b:SparseFormalPowerSeries[T], deg = -1):SparseFormalPowerSeries[T] =
    var r = initTable[int,T]()
    for (i, c0) in a:
      for (j, c1) in b:
        let k = i + j
        if deg != -1 and k >= deg: continue
        if k notin r: r[k] = T(0)
        r[k] += c0 * c1
    return toSeq(r.pairs)

  proc `*=`*[T](self: var FormalPowerSeries[T],  r: FormalPowerSeries[T]) =
    if self.len == 0 or r.len == 0:
      self.setlen(0)
    else:
      when T is ModInt:
        self = T.get_fft_type().convolution(self, r)
#        when T is StaticModInt and T.isGoodMod:
#          self = convolution.convolution(self, r)
#        else:
#          self = arbitrary_mod_convolution.convolution(self, r)
      else:
        var res = initFormalPowerSeries[T](self.len + r.len - 1)
        for i in 0..<self.len:
          for j in 0..<r.len:
            res += self[i] * r[j]
        swap(self, res)
 
  proc `mod=`*[T](self: var FormalPowerSeries[T], r:FormalPowerSeries[T]) = self -= self div r * r
  
  proc `-`*[T](self: FormalPowerSeries[T]):FormalPowerSeries[T] =
    var ret = self
    ret.applyIt(-it)
    return ret
  proc `/=`*[T](self: var FormalPowerSeries[T], v:T) = self.applyIt(it / v)
  #}}}

  proc rev*[T](self: FormalPowerSeries[T], deg = -1):auto =
    result = self
    if deg != -1: result.setlen(deg)
    result.reverse
  
  proc pre*[T](self: FormalPowerSeries[T], sz:int):auto =
    result = self
    result.setlen(min(self.len, sz))
  
  proc `shr`*[T](self: FormalPowerSeries[T], sz:int):auto =
    if self.len <= sz: return initFormalPowerSeries[T](0)
    result = self
    if sz >= 1: result.delete(0, sz - 1)
  proc `shl`*[T](self: FormalPowerSeries[T], sz:int):auto =
    result = initFormalPowerSeries[T](sz)
    result = result & self
  
  proc diff*[T](self: FormalPowerSeries[T]):auto =
    let n = self.len
    result = initFormalPowerSeries[T](max(0, n - 1))
    for i in 1..<n:
      result[i - 1] = self[i] * T(i)
  
  proc integral*[T](self: FormalPowerSeries[T]):auto =
    let n = self.len
    result = initFormalPowerSeries[T](n + 1)
    result[0] = T(0)
    for i in 0..<n: result[i + 1] = self[i] / T(i + 1)
  
  # F(0) must not be 0
  proc inv*[T](self: FormalPowerSeries[T], deg = -1):auto =
    assert(self[0] != 0)
    deg.revise(self.len)
    type F = T.get_fft_type()
    when T is ModInt:
      proc invFast[T](self: FormalPowerSeries[T]):auto =
        assert(self[0] != 0)
        let n = self.len
        var res = initFormalPowerSeries[T](1)
        res[0] = T(1) / self[0]
        var d = 1
        while d < n:
          var f, g = initFormalPowerSeries[T](2 * d)
          for j in 0..<min(n, 2 * d): f[j] = self[j]
          for j in 0..<d: g[j] = res[j]
          let g1 = F.fft(g)
          f = ifft[T](F, dot(F.fft(f), g1))
          for j in 0..<d:
            f[j] = T(0)
            f[j + d] = -f[j + d]
          f = ifft[T](F, dot(F.fft(f), g1))
          f[0..<d] = res[0..<d]
          res = f
          d = d shl 1
        return res.pre(n)
      var ret = self
      ret.setlen(deg)
      return ret.invFast()
    else:
      var ret = initFormalPowerSeries[T](1)
      ret[0] = T(1) / self[0]
      var i = 1
      while i < deg:
        ret = (ret + ret - ret * ret * self.pre(i shl 1)).pre(i shl 1)
        i = i shl 1
      return ret.pre(deg)
  proc `/=`*[T](self: var FormalPowerSeries[T], r: FormalPowerSeries[T]) =
    self *= r.inv()

  proc `div=`*[T](self: var FormalPowerSeries[T], r: FormalPowerSeries[T]) =
    if self.len < r.len:
      self.setlen(0)
    else:
      let n = self.len - r.len + 1
      self = (self.rev().pre(n) * r.rev().inv(n)).pre(n).rev(n)
  
  template toFormalPowerSeries[T](f:FormalPowerSeries[T] or T or SomeNumber):auto =
    when f is SomeNumber or f is T: initFormalPowerSeries[T](@[T(f)])
    else: initFormalPowerSeries[T](f)

  # operators +, -, *, div, mod {{{
  macro declareOp(op) =
    fmt"""proc `{op}`*[T](self:FormalPowerSeries[T];r:FormalPowerSeries[T] or T):FormalPowerSeries[T] = result = self;result {op}= r
proc `{op}`*[T](self: not FormalPowerSeries, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = initFormalPowerSeries[T](@[T(self)]);result {op}= r""".parseStmt
  
  declareOp(`+`)
  declareOp(`-`)
  declareOp(`*`)
  declareOp(`/`)
  
  proc `div`*[T](self, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`div=` (r)
  proc `mod`*[T](self, r:FormalPowerSeries[T]):FormalPowerSeries[T] = result = self;result.`mod=` (r)
  # }}}
  
  # F(0) must be 1
  proc log*[T](self:FormalPowerSeries[T], deg = -1):auto =
    assert self[0] == T(1)
    deg.revise(self.len)
    return (self.diff() * self.inv(deg)).pre(deg - 1).integral()
  
  proc sqrt*[T](self: FormalPowerSeries[T], deg = -1):auto =
    let n = self.len
    deg.revise(n)
    if self[0] == 0:
      for i in 1..<n:
        if self[i] != 0:
          if (i and 1) > 0: return FormalPowerSeries[T].none
          if deg - i div 2 <= 0: break
          var opt = (self shr i).sqrt(deg - i div 2)
          if not opt.isSome: return FormalPowerSeries[T].none
          var ret = opt.get shl (i div 2)
          if ret.len < deg: ret.setlen(deg)
          return ret.some
      return initFormalPowerSeries[T](deg).some
  
    var ret:FormalPowerSeries[T]
    if self.isSetSqrt:
      let opt = self.getSqrt()(self[0])
      if not opt.isSome: return FormalPowerSeries[T].none
      ret = initFormalPowerSeries[T](@[T(opt.get)])
    else:
      assert(self[0] == 1)
      ret = initFormalPowerSeries[T](@[T(1)])
  
    let inv2 = T(1) / T(2)
    var i = 1
    while i < deg:
      ret = (ret + self.pre(i shl 1) * ret.inv(i shl 1)) * inv2
      i = i shl 1
    return ret.pre(deg).some
  
#  import typetraits
  
  # F(0) must be 0
  proc exp*[T](self: FormalPowerSeries[T], deg = -1):auto =
    assert self[0] == 0
    deg.revise(self.len)
    when T is ModInt:
      proc onlineConvolutionExp[T](self, conv_coeff:FormalPowerSeries[T]):auto =
        let n = conv_coeff.len
        assert((n and (n - 1)) == 0)
        type F = T.get_fft_type()
        type FFTType = F.fft(initFormalPowerSeries[T](0)).type
        var
          conv_ntt_coeff = newSeq[FFTType]()
          i = n
        while (i shr 1) > 0:
          var g = conv_coeff.pre(i)
          conv_ntt_coeff.add(F.fft(g))
          i = i shr 1
        var conv_arg, conv_ret = initFormalPowerSeries[T](n)
        proc rec(l,r,d:int) =
          if r - l <= 16:
            for i in l..<r:
              var sum = T(0)
              for j in l..<i: sum += conv_arg[j] * conv_coeff[i - j]
              conv_ret[i] += sum
              conv_arg[i] = if i == 0: T(1) else: conv_ret[i] / i
          else:
            var m = (l + r) div 2
            rec(l, m, d + 1)
            var pre = initFormalPowerSeries[T](r - l)
            pre[0..<m-l] = conv_arg[l..<m]
            pre = ifft[T](F, dot(F.fft(pre), conv_ntt_coeff[d]))
            for i in 0..<r - m: conv_ret[m + i] += pre[m + i - l]
            rec(m, r, d + 1)
        rec(0, n, 0)
        return conv_arg
      proc expRec[T](self: FormalPowerSeries[T]):auto =
        assert self[0] == 0
        let n = self.len
        var m = 1
        while m < n: m *= 2
        var conv_coeff = initFormalPowerSeries[T](m)
        for i in 1..<n: conv_coeff[i] = self[i] * i
        return self.onlineConvolutionExp(conv_coeff).pre(n)
      var ret = self
      ret.setlen(deg)
      return ret.expRec()
    else:
      var
        ret = initFormalPowerSeries[T](@[T(1)])
        i = 1
      while i < deg:
        ret = (ret * (self.pre(i shl 1) + T(1) - ret.log(i shl 1))).pre(i shl 1);
        i = i shl 1
      return ret.pre(deg)
  
#  proc exponent*[T](a:FormalPowerSeries[T]):FormalPowerSeries[T] =
#    assert(a.len == 0 or a[0] == 0);
#    var
#      a = a
#      b = initFormalPowerSeries[T]([1])
#    while b.len < a.len:
#      var x = a[0..<min(a.len, 2 * b.len)]
#      x[0] += 1
#      b.setLen(2 * b.len)
#      x -= log(b)
#      let l = b.len div 2
#      x *= b[0..<l]
#      for i in l..<min(x.len, b.len):
#        b[i] = x[i]
#    return b[0..<a.len]
  
  proc pow*[T](self: FormalPowerSeries[T], k:int, deg = -1):auto =
    var self = self
    let n = self.len
    deg.revise(n)
    self.setLen(deg)
    for i in 0..<n:
      if self[i] != T(0):
        let rev = T(1) / self[i]
        result = (((self * rev) shr i).log(deg) * T.init(k)).exp() * (self[i].pow(k))
        if i * k > deg: return initFormalPowerSeries[T](deg)
        result = (result shl (i * k)).pre(deg)
        if result.len < deg: result.setlen(deg)
        return
    return self
  
  proc eval*[T](self: FormalPowerSeries[T], x:T):T =
    var
      r = T(0)
      w = T(1)
    for v in self:
      r += w * v
      w *= x
    return r
  
  proc powMod*[T](self: FormalPowerSeries[T], n:int, M:FormalPowerSeries[T]):auto =
    let modinv = M.rev().inv()
    proc getDiv(base:FormalPowerSeries[T]):FormalPowerSeries[T] =
      var base = base
      if base.len < M.len:
        base.setlen(0)
        return base
      let n = base.len - M.len + 1
      return (base.rev().pre(n) * modinv.pre(n)).pre(n).rev(n)
    var
      n = n
      x = self
      ret = initFormalPowerSeries[T](@[T(1)])
    while n > 0:
      if (n and 1) > 0:
        ret *= x
        ret -= getDiv(ret) * M
      x *= x
      x -= getDiv(x) * M
      n = n shr 1
    return ret
# }}}

proc main() =
  type mint = modint998244353
  type FPS = FormalPowerSeries[mint]
#  var f = initFormalPowerSeries[mint](N)
  var f = FPS.init(N)
  for i in 0..<K:
    for j in L[i]..R[i]:
      if j < N:
        f[j] = mint(1)
  f = 1/(1 - f)
  echo f[N - 1]
  return

main()

