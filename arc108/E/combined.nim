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
    template `min=`*(x,y:typed):void = x = min(x,y)
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

when not declared ATCODER_MODINT_HPP:
  const ATCODER_MODINT_HPP* = 1
  import std/macros
  import std/strformat
  when not declared ATCODER_GENERATE_DEFINITIONS_NIM:
    const ATCODER_GENERATE_DEFINITIONS_NIM* = 1
    import std/strformat
    import std/macros
  
    template generateDefinitions*(name, l, r, typeObj, typeBase, body: untyped): untyped {.dirty.} =
      proc name*(l, r: typeObj): auto {.inline.} =
        type T = l.type
        body
      proc name*(l: typeBase; r: typeObj): auto {.inline.} =
        type T = r.type
        body
      proc name*(l: typeObj; r: typeBase): auto {.inline.} =
        type T = l.type
        body
  
    template generatePow*(name) {.dirty.} =
      proc pow*(m: name; p: SomeInteger): name {.inline.} =
        assert (p.type)(0) <= p
        var
          p = p.uint
          m = m
        result = m.unit()
        while p > 0'u:
          if (p and 1'u) != 0'u: result *= m
          m *= m
          p = p shr 1'u
      proc `^`*[T:name](m: T; p: SomeInteger): T {.inline.} = m.pow(p)
  
    macro generateConverter*(name, from_type, to_type) =
      parseStmt(fmt"""type {name.repr}* = {to_type.repr}{'\n'}converter to{name.repr}OfGenerateConverter*(a:{from_type}):{name.repr} {{.used.}} = {name.repr}.init(a){'\n'}""")
    discard

  type
    StaticModInt*[M: static[int]] = object
      a:uint32
    DynamicModInt*[T: static[int]] = object
      a:uint32

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

  proc getBarrett*[T:static[int]](t:typedesc[DynamicModInt[T]]):ptr Barrett =
    var Barrett_of_DynamicModInt {.global.} = initBarrett(998244353.uint)
    return Barrett_of_DynamicModInt.addr
  proc getMod*[T:static[int]](t:typedesc[DynamicModInt[T]]):uint32 {.inline.} =
    (t.getBarrett)[].m.uint32
  proc setMod*[T:static[int]](t:typedesc[DynamicModInt[T]], M:SomeInteger){.used inline.} =
    (t.getBarrett)[] = initBarrett(M.uint)

  proc `$`*(m: ModInt): string {.inline.} = $(m.val())

  template umod*[T:ModInt](self: typedesc[T] or T):uint32 =
    when T is typedesc:
      when T is StaticModInt:
        T.M.uint32
      elif T is DynamicModInt:
        T.getMod()
      else:
        static: assert false
    else: T.umod

  proc `mod`*[T:ModInt](self:typedesc[T] or T):int = T.umod.int

  proc init*[T:ModInt](t:typedesc[T], v: SomeInteger or T): auto {.inline.} =
    when v is T: return v
    else:
      when v is SomeUnsignedInt:
        if v.uint < T.umod:
          return T(a:v.uint32)
        else:
          return T(a:(v.uint mod T.umod.uint).uint32)
      else:
        var v = v.int
        if 0 <= v:
          if v < T.mod: return T(a:v.uint32)
          else: return T(a:(v mod T.mod).uint32)
        else:
          v = v mod T.mod
          if v < 0: v += T.mod
          return T(a:v.uint32)
  proc unit*[T:ModInt](t:typedesc[T] or T):T = T.init(1)
  template initModInt*(v: SomeInteger or ModInt; M: static[int] = 1_000_000_007): auto =
    StaticModInt[M].init(v)

# TODO
#  converter toModInt[M:static[int]](n:SomeInteger):StaticModInt[M] {.inline.} = initModInt(n, M)

#  proc initModIntRaw*(v: SomeInteger; M: static[int] = 1_000_000_007): auto {.inline.} =
#    ModInt[M](v.uint32)
  proc raw*[T:ModInt](t:typedesc[T], v:SomeInteger):auto = T(a:v)

  proc inv*[T:ModInt](v:T):T {.inline.} =
    var
      a = v.a.int
      b = T.mod
      u = 1
      v = 0
    while b > 0:
      let t = a div b
      a -= t * b;swap(a, b)
      u -= t * v;swap(u, v)
    return T.init(u)

  proc val*(m: ModInt): int {.inline.} = int(m.a)

  proc `-`*[T:ModInt](m: T): T {.inline.} =
    if int(m.a) == 0: return m
    else: return T(a:m.umod() - m.a)

  proc `+=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a += T.init(n).a
    if m.a >= T.umod: m.a -= T.umod

  proc `-=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a -= T.init(n).a
    if m.a >= T.umod: m.a += T.umod

  proc `*=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    when T is StaticModInt:
      m.a = (m.a.uint * T.init(n).a.uint mod T.umod).uint32
    elif T is DynamicModInt:
      m.a = T.getBarrett[].mul(m.a.uint, T.init(n).a.uint).uint32
    else:
      static: assert false

  proc `/=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a = (m.a.uint * T.init(n).inv().a.uint mod T.umod).uint32

  generateDefinitions(`+`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result += n

  generateDefinitions(`-`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result -= n

  generateDefinitions(`*`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result *= n

  generateDefinitions(`/`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result /= n

  generateDefinitions(`==`, m, n, ModInt, SomeInteger):
    result = (T.init(m).val() == T.init(n).val())

  proc inc*(m: var ModInt) {.inline.} =
    m.a.inc
    if m.a == m.umod.uint32:
      m.a = 0

  proc dec*(m: var ModInt) {.inline.} =
    if m.a == 0.uint32:
      m.a = m.umod - 1
    else:
      m.a.dec

  generatePow(ModInt)

  template useStaticModint*(name, M) =
    generateConverter(name, int, StaticModInt[M])
  template useDynamicModInt*(name, M) =
    generateConverter(name, int, DynamicModInt[M])

  useStaticModInt(modint998244353, 998244353)
  useStaticModInt(modint1000000007, 1000000007)
  useDynamicModInt(modint, -1)
when not declared ATCODER_FENWICKTREE_HPP:
  const ATCODER_FENWICKTREE_HPP* = 1
  import std/sequtils
  when not declared ATCODER_INTERNAL_TYPE_TRAITS_HPP:
    const ATCODER_INTERNAL_TYPE_TRAITS_HPP* = 1
  
    ##ifndef _MSC_VER
    #template <class T>
    #using is_signed_int128 =
    #    typename std::conditional<std::is_same<T, __int128_t>::value ||
    #                                  std::is_same<T, __int128>::value,
    #                              std::true_type,
    #                              std::false_type>::type;
    #
    #template <class T>
    #using is_unsigned_int128 =
    #    typename std::conditional<std::is_same<T, __uint128_t>::value ||
    #                                  std::is_same<T, unsigned __int128>::value,
    #                              std::true_type,
    #                              std::false_type>::type;
    #
    #template <class T>
    #using make_unsigned_int128 =
    #    typename std::conditional<std::is_same<T, __int128_t>::value,
    #                              __uint128_t,
    #                              unsigned __int128>;
    #
    #template <class T>
    #using is_integral = typename std::conditional<std::is_integral<T>::value ||
    #                                                  is_signed_int128<T>::value ||
    #                                                  is_unsigned_int128<T>::value,
    #                                              std::true_type,
    #                                              std::false_type>::type;
    #
    #template <class T>
    #using is_signed_int = typename std::conditional<(is_integral<T>::value &&
    #                                                 std::is_signed<T>::value) ||
    #                                                    is_signed_int128<T>::value,
    #                                                std::true_type,
    #                                                std::false_type>::type;
    #
    #template <class T>
    #using is_unsigned_int =
    #    typename std::conditional<(is_integral<T>::value &&
    #                               std::is_unsigned<T>::value) ||
    #                                  is_unsigned_int128<T>::value,
    #                              std::true_type,
    #                              std::false_type>::type;
    #
    #template <class T>
    #using to_unsigned = typename std::conditional<
    #    is_signed_int128<T>::value,
    #    make_unsigned_int128<T>,
    #    typename std::conditional<std::is_signed<T>::value,
    #                              std::make_unsigned<T>,
    #                              std::common_type<T>>::type>::type;
    #
    ##else
    
    #  template <class T> using is_integral = typename std::is_integral<T>;
      
    #  template <class T>
    #  using is_signed_int =
    #      typename std::conditional<is_integral<T>::value && std::is_signed<T>::value,
    #                                std::true_type,
    #                                std::false_type>::type;
    #  
    #  template <class T>
    #  using is_unsigned_int =
    #      typename std::conditional<is_integral<T>::value &&
    #                                    std::is_unsigned<T>::value,
    #                                std::true_type,
    #                                std::false_type>::type;
    #  
    #  template <class T>
    #  using to_unsigned = typename std::conditional<is_signed_int<T>::value,
    #                                                std::make_unsigned<T>,
    #                                                std::common_type<T>>::type;
    
    template to_unsigned*(T:typedesc):typedesc =
      when T is int: uint
      elif T is int8: uint8
      elif T is int16: uint16
      elif T is int32: uint32
      elif T is int64: uint64
      else: T
      
  #endif
  
  #template <class T>
  #using is_signed_int_t = std::enable_if_t<is_signed_int<T>::value>;
  #
  #template <class T>
  #using is_unsigned_int_t = std::enable_if_t<is_unsigned_int<T>::value>;
  #
  #template <class T> using to_unsigned_t = typename to_unsigned<T>::type;
  
    template to_unsigned_t*(T):typed = to_unsigned(T)
  
  #
  #}  // namespace internal
  #
  #}  // namespace atcoder
  
  #endif  // ATCODER_INTERNAL_TYPE_TRAITS_HPP
    discard

  # Reference: https://en.wikipedia.org/wiki/Fenwick_tree
  type FenwickTree*[T, U] = object
    n*:int
    data*:seq[U]

  proc init*(self:typedesc[FenwickTree], n:int):auto =
    return self(n:n, data:newSeqWith(n, self.U(0)))
  proc init*(self:var FenwickTree, n:int) =
    if self.data.len < n: self.data.setLen(n)
    self.data.fill(0, n - 1, self.U(0))
    self.n = n

  template getFenwickTreeType*(T:typedesc):typedesc[FenwickTree] =
    type U = to_unsigned(T)
    typedesc[FenwickTree[T, U]]
  template getType*(FT:typedesc[FenwickTree], T:typedesc):typedesc[FenwickTree] =
    getFenwickTreeType(T)
  proc initFenwickTree*[T](n:int):auto = FenwickTree.getType(T).init(n)

  proc add*[FT:FenwickTree](self: var FT, p:int, x:FT.T) =
    assert p in 0..<self.n
    var p = p + 1
    while p <= self.n:
      self.data[p - 1] += FT.U(x)
      p += p and -p
  proc sum[FT:FenwickTree](self: FT, r:int):auto =
    result = FT.U(0)
    var r = r
    while r > 0:
      result += self.data[r - 1]
      r -= r and -r
  proc sum*[FT:FenwickTree](self: FT, p:Slice[int]):FT.T =
    let (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    return cast[FT.T](self.sum(r) - self.sum(l))
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
    type FieldElem* = concept x, y, type T
      x + y
      x - y
      x * y
      x / y
      -x
      x.inv()
      T(0)
      T(1)
    type FiniteFieldElem* = concept x, type T
      T is FieldElem
      T.mod
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
  template P_large*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else:
      var a = T(1)
      for i in 0..<r:a *= n - i
      a
  template C_large*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.P_large(n, r) * T.rfact(r)
  template H_large*(T:CombinationC, n,r:int):auto =
    if n < 0 or r < 0: T.zero()
    elif r == 0: T.zero() + 1
    else: T.C_large(n + r - 1, r)
# }}}

type mint = modint1000000007

var dp = Array(2002, 2002, mint(0))

proc solve(N:int, a:seq[int]) =
  let a = 0 & a & N + 1
  type ftt = FenwickTree.getType(mint)
  var ftr = newSeqWith(a.len, ftt.init(a.len))
  var ftl = ftt.init(a.len)
  var ct = getFenwickTreeType(int).init(a.len)
  for l in reversed(0..<a.len):
    ct.init(a.len)
    ftl.init(a.len)
    for r in l + 1..<a.len:
      if a[l] > a[r]: continue
      let c = ct.sum(0..a[r])
      ct.add(a[r], 1)
      if c == 0: continue
      dp[l][r] = (ftl.sum(a[l]+1..<a[r]) + ftr[r].sum(a[l]+1..<a[r])) * mint.inv(c) + 1
      ftl.add(a[r], dp[l][r])
      ftr[r].add(a[l], dp[l][r])
  echo dp[0][N + 1]
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
#}}}
