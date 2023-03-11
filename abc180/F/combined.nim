# header {{{
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
# combination {{{
when not defined ATCODER_COMBINATION_HPP:
  const ATCODER_COMBINATION_HPP* = 1
  when not declared ATCODER_ELEMENT_CONCEPTS_HPP:
    const ATCODER_ELEMENT_CONCEPTS_HPP* = 1
    proc inv*[T:SomeFloat](a:T):auto = T(1) / a
    proc init*(self:typedesc[SomeFloat], a:SomeNumber):auto = self(a)
    type AdditiveGroupElem* = concept x, type T
      x + x
      x - x
      -x
      T(0)
    type MultiplicativeGroupElem* = concept x, type T
      x * x
      x / x
  #    x.inv()
      T(1)
    type RingElem* = concept x, type T
      x + x
      x - x
      -x
      x * x
      T(0)
      T(1)
    type FieldElem* = concept x, type T
      x + x
      x - x
      x * x
      x / x
      -x
  #    x.inv()
      T(0)
      T(1)
    type FiniteFieldElem* = concept x, type T
      x is FieldElem
      T.mod()
      T.mod() is int
      x.pow(1000000)
    type hasInf* = concept x, type T
      T(Inf)
    discard

  type Combination*[T] = object
    fact_a, rfact_a: seq[T]

  type CombinationC* = concept x
    x is typedesc[FieldElem] or x is var Combination

  proc enhance[T:FieldElem](cmb: var Combination[T], k:int):auto =
    if k >= cmb.fact_a.len:
      if cmb.fact_a.len == 0:
        cmb.fact_a = @[T(1)]
        cmb.rfact_a = @[T(1)]
      let sz_old = cmb.fact_a.len - 1
      let sz = max(sz_old * 2, k)
      cmb.fact_a.setlen(sz + 1)
      cmb.rfact_a.setlen(sz + 1)
      for i in sz_old + 1..sz: cmb.fact_a[i] = cmb.fact_a[i-1] * T(i)
      cmb.rfact_a[sz] = T(1) / cmb.fact_a[sz]
      for i in countdown(sz - 1, sz_old + 1): cmb.rfact_a[i] = cmb.rfact_a[i + 1] * T(i + 1)
    return cmb.addr

  proc enhance(T:typedesc[FieldElem], k:int):auto {.discardable.} =
    var cmb{.global.} = Combination[T]()
    return cmb.enhance(k)
  
  template zero*(T:typedesc[FieldElem]):T = T(0)
  template zero*[T:FieldElem](cmb:Combination[T]):T = T(0)
  
  template fact*(T:CombinationC, k:int):auto = T.enhance(k)[].fact_a[k]
  template rfact*(T:CombinationC, k:int):auto = T.enhance(k)[].rfact_a[k]
  template inv*(T:CombinationC, k:int):auto = T.fact(k - 1) * T.rfact(k)

  template resetCombination*(T:typedesc[FieldElem] or var Combination) =
    var p = T.enhance(-1)
    p[].fact_a.setLen(0)
    p[].rfact_a.setLen(0)
  
  template P*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.fact(n) * T.rfact(n - r)
  template C*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.fact(n) * T.rfact(r) * T.rfact(n - r)
  template H*(T:CombinationC, n,r:int):auto =
    if n < 0 or r < 0: T.zero()
    elif r == 0: T.zero() + 1
    else: T.C(n + r - 1, r)
# }}}

const MOD = 1000000007
type mint = modint1000000007

let f2 = mint(1) / mint(2)

proc cycle(n:int):auto =
  if n <= 2: return mint(1)
  else: return mint.fact(n - 1) * f2

proc path(n:int):auto =
  if n <= 2: return mint(1)
  else: return mint.fact(n) * f2

proc solve(N:int, M:int, L:int) =
  if L == 1:
    if M > 0: echo 0
    else: echo 1
    return
  var dp = Seq(N + 1, M + 1, 2, mint(0))
  dp[0][0][0] = mint(1)
  for n in 0..<N:
    let d = N - n
    for m in 0..M:
      # isolated
      dp[n + 1][m][0] += dp[n][m][0]
      dp[n + 1][m][1] += dp[n][m][1]
      for t in 2..L:
        # add t
        if t > d: break
#        if t == 2 and n == 0 and m == 0:
#          echo "nya"
        # cycle
        if m + t <= M:
          if t < L:
            dp[n + t][m + t][0] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][0]
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][1]
          else:
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][0]
            dp[n + t][m + t][1] += mint.C(d - 1, t - 1) * cycle(t) * dp[n][m][1]
        # path
        if m + t - 1 <= M:
          if t < L:
            dp[n + t][m + t - 1][0] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][0]
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][1]
          else:
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][0]
            dp[n + t][m + t - 1][1] += mint.C(d - 1, t - 1) * path(t) * dp[n][m][1]
  echo dp[N][M][1]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  solve(N, M, L)
#}}}
