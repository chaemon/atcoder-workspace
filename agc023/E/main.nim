#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
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

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var N:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt() - 1)
#}}}

import future

#{{{ LazySegmentTree[D, L](n,f_DD,f_DL,f_LL,D0,L0)

type LazySegmentTree[D, L] = object
  sz, height: int
  f_DD: (D, D) -> D
  f_DL: (D, L) -> D
  f_LL: (L, L) -> L
  data: seq[D]
  lazy: seq[L]
  D0: D
  L0: L

proc initLazySegmentTree[D, L](n: int, f_DD: (D, D)->D, f_DL: (D, L)->D, f_LL:(L, L)->L, D0: D, L0: L): LazySegmentTree[D, L] =
  var
    sz = 1
    height = 0
  while sz < n: sz *= 2;height += 1
  var
    data = newSeqWith(sz * 2, D0)
    lazy = newSeqWith(sz * 2, L0)
  return LazySegmentTree[D, L](sz:sz, height:height, f_DD:f_DD, f_DL:f_DL, f_LL:f_LL, data:data, lazy:lazy, D0:D0, L0:L0)

# preset and build {{{
proc preset[D, L](self: var LazySegmentTree[D,L], k:int, x:D) =
  self.data[k + self.sz] = x

proc build[D, L](self: var LazySegmentTree[D,L]) =
  for k in countdown(self.sz - 1, 1):
    self.data[k] = self.f_DD(self.data[2*k], self.data[2*k+1])

proc build[D, L](self: var LazySegmentTree[D,L], v:seq[D]) =
  for i in 0..<self.sz:
    self.data[i + self.sz] = if i < v.len: v[i] else: self.D0
  self.build()

proc reflect[D, L](self:LazySegmentTree[D, L], k:int):D =
  if self.lazy[k] == self.L0:
    return self.data[k]
  else:
    return self.f_DL(self.data[k], self.lazy[k])
# }}}

proc propagate[D, L](self: var LazySegmentTree[D, L], k:int) =
  if self.lazy[k] != self.L0:
    self.lazy[2 * k + 0] = self.f_LL(self.lazy[2 * k + 0], self.lazy[k])
    self.lazy[2 * k + 1] = self.f_LL(self.lazy[2 * k + 1], self.lazy[k])
    self.data[k] = self.reflect(k)
    self.lazy[k] = self.L0

proc recalc[D, L](self: var LazySegmentTree[D, L], k:int) =
  var k = k div 2
  while k > 0:
    self.data[k] = self.f_DD(self.reflect(2 * k + 0), self.reflect(2 * k + 1))
    k = k div 2

proc thrust[D, L](self: var LazySegmentTree[D, L], k:int) =
  for i in countdown(self.height, 1):
    self.propagate(k shr i)

proc update[D, L](self: var LazySegmentTree[D, L], p:Slice[int], x:L) =
  let
    a = p.a + self.sz
    b = p.b + self.sz
  self.thrust(a)
  self.thrust(b)
  var
    l = a
    r = b + 1
  while l < r:
    if (l and 1) > 0: self.lazy[l] = self.f_LL(self.lazy[l], x);l += 1
    if (r and 1) > 0: r -= 1;self.lazy[r] = self.f_LL(self.lazy[r], x)
    l = (l shr 1);r = (r shr 1)
  self.recalc(a);
  self.recalc(b);

proc `[]`[D, L](self: var LazySegmentTree[D, L], p:Slice[int]):D =
  let (a, b) = (p.a + self.sz, p.b + self.sz)
  self.thrust(a)
  self.thrust(b)
  var
    L, R = self.D0
    (l, r) = (a, b + 1)
  while l < r:
    if (l and 1) > 0: L = self.f_DD(L, self.reflect(l));l += 1
    if (r and 1) > 0: r -= 1;R = self.f_DD(self.reflect(r), R)
    l = l shr 1;r = r shr 1
  return self.f_DD(L, R);

proc `[]`[D, L](self: var LazySegmentTree[D, L], k:int):D =
  return self[k..k]
proc `[]=`[D, L](self: var LazySegmentTree[D, L], k:int, x:D) =
  let
    a = k + self.sz
  self.thrust(a)
  self.data[a] = x
  self.lazy[a] = self.L0
  self.recalc(a);

# findFirst and find Last {{{
proc findSubtree[D, L](self: var LazySegmentTree[D, L], a:int, check:proc(a:D):bool, M:var D, t:int):int =
  var a = a
  while a < self.sz:
    self.propagate(a)
    let nxt = if t != 0: self.f_DD(self.reflect(2 * a + t), M) else: self.f_DD(M, self.reflect(2 * a + t))
    if check(nxt): a = 2 * a + t
    else: M = nxt;a = 2 * a + 1 - t
  return a - self.sz

proc findFirst[D, L](self: var LazySegmentTree[D, L], a:int, check:proc(a:D):bool):int =
  var
    L = self.D0
    a = a
  if a <= 0:
    if check(self.f_DD(L, self.reflect(1))): return self.find_subtree(1, check, L, 0)
    return -1
  self.thrust(a + self.sz)
  var b = self.sz
  a += self.sz
  b += self.sz
  while a < b:
    if (a and 1) > 0:
      let nxt = self.f_DD(L, self.reflect(a))
      if check(nxt): return self.find_subtree(a, check, L, 0)
      L = nxt
      a += 1
    a = a shr 1
    b = b shr 1
  return -1;

proc findLast[D, L](self: var LazySegmentTree[D, L], b:int, check:proc(a:D):bool):int =
  var
    R = self.D0
    b = b
  if b >= self.sz:
    if check(self.f_DD(self.reflect(1), R)): return self.find_subtree(1, check, R, 1)
    return -1
  self.thrust(b + self.sz - 1)
  var a = self.sz
  b += self.sz
  while a < b:
    if (b and 1) > 0:
      b -= 1
      let nxt = self.f_DD(self.reflect(b), R)
      if check(nxt): return self.find_subtree(b, check, R, 1)
      R = nxt;
    a = a shr 1
    b = b shr 1
  return -1
# }}}

proc `$`[D, L](self: var LazySegmentTree[D, L]):string =
  result = ""
  for i in 0..<self.sz:
    result.add(" " & $(self[i]) & " ")

proc output[D, L](self: LazySegmentTree[D, L]) =
  echo "=== begin ==="
  var s = 1
  for h in 0..self.height:
    for i in s..<s*2: stdout.write self.data[i],"/",self.lazy[i], " - "
    echo ""
    s *= 2
  echo "=== end ==="

#}}}

type D = tuple[n,s,t:int]
type L = int

proc f_DD(a, b: D):D =
  return (a.n + b.n, a.s + b.s, a.t + b.s * a.n + b.t)
proc f_DL(a:D, l:L):D =
  return (a.n, a.s + a.n * l, a.t + l * a.n * (a.n - 1) div 2)
proc f_LL(a, b:L):L = a + b

proc main() =
  st := initLazySegmentTree[D, L](N, f_DD, f_DL, f_LL, (0, 0, 0), 0)
  st.build((1, 0, 0).repeat(N))
  for i in countdown(N - 1, 0):
    dump(i)
    echo $st
    a := st[0..<A[i]]
    dump(a)
    dump(A[i] * a.s - a.t)
    st.update(0..A[i], 1)
  return

main()
