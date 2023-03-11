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

  proc val*(m: ModInt): int {.inline.} =
    int(m.a)

  proc `-`*[T:ModInt](m: T): T {.inline.} =
    if int(m.a) == 0: return m
    else: return T(a:m.umod() - m.a)

  template generateDefinitions(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*[T:ModInt](l: T; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: SomeInteger; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: T; r: SomeInteger): auto {.inline.} =
      body
  template generateDefinitions2(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*[T:ModInt](l: SomeInteger; r: T): auto {.inline.} =
      body
    proc name*[T:ModInt](l: T; r: SomeInteger): auto {.inline.} =
      body

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

  generateDefinitions2(`==`, m, n):
    result = (T.init(m).a == T.init(n).a)

  proc inc*[T:ModInt](m: var T) {.inline.} =
    m.a.inc
    if m == T.umod:
      m.a = 0

  proc dec*[T:ModInt](m: var T) {.inline.} =
    if m == 0:
      m.a = T.umod - 1
    else:
      m.a.dec

  proc pow*[T:ModInt](m: T; p: SomeInteger): T {.inline.} =
    assert 0 <= p
    var
      p = p.int
      m = m
    result.a = 1
    while p > 0:
      if (p and 1) == 1:
        result *= m
      m *= m
      p = p shr 1
  proc `^`*[T:ModInt](m: T; p: SomeInteger): T {.inline.} = m.pow(p)

  macro useStaticModInt*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = StaticModInt[{M.repr}.int]{'\n'}proc `$`*(m: {name.repr}): string {{.used.}} = system.`$`(m.val()){'\n'}converter to{name.repr}OfModInt*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
    parseStmt(strBody)
  macro useDynamicModInt*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = DynamicModInt[{M.repr}.int]{'\n'}proc `$`*(m: {name.repr}): string {{.used.}} = system.`$`(m.val()){'\n'}converter to{name.repr}OfModInt*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
    parseStmt(strBody)

  useStaticModInt(modint998244353, 998244353)
  useStaticModInt(modint1000000007, 1000000007)
  useDynamicModInt(modint, -1)
const MOD = 1000000007
type mint = modint1000000007

type St = object
  t, r, d, rd:mint

proc solve() =
  let H, W = nextInt()
  let S = Seq(H, nextString())
  var dp = Seq(H, W, St)
  var vis = Seq(H, W, false)
  dp[0][0].t = mint(1)
  for i in 0..<H:
    for j in 0..<W:
      dp[i][j].t += dp[i][j].r + dp[i][j].d + dp[i][j].rd
      if i + 1 < H and S[i + 1][j] != '#':
        dp[i + 1][j].d += dp[i][j].d + dp[i][j].t
      if j + 1 < W and S[i][j + 1] != '#':
        dp[i][j + 1].r += dp[i][j].r + dp[i][j].t
      if i + 1 < H and j + 1 < W and S[i + 1][j + 1] != '#':
        dp[i + 1][j + 1].rd += dp[i][j].rd + dp[i][j].t
  echo dp[H - 1][W - 1].t
  return

# input part {{{
block:
  solve()
#}}}
