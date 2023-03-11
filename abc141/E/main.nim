#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

# {{{ Rolling Hash
import sequtils

# {{{ RollingHashOp[Mod]
type RollingHashOp[Mod:static[uint]] = object
  discard

proc mult(T:typedesc[RollingHashOp], a,b:uint):uint =
  return (a * b) mod T.Mod
#  let
#    x = a * b
#    xh = (x shr 32'u)
#    xl = x
#  var d, m:uint
#  asm """ "divl %4; \n\t" : "=a" (d), "=d" (m) : "d" (xh), "a" (xl), "r" (MOD));" """
#  return m
proc multRaw(T:typedesc[RollingHashOp], a,b:uint):uint = a * b
proc calcMod(T:typedesc[RollingHashOp], a:uint):uint = a mod T.Mod
# }}}

# {{{ FastRollingHashOp
type FastRollingHashOpBase[MASK30:static[uint], MASK31:static[uint], MOD:static[uint], MASK61:static[uint]] = object
  discard
type FastRollingHashOp = FastRollingHashOpBase[(1'u shl 30) - 1, (1'u shl 31) - 1, (1'u shl 61) - 1, (1'u shl 61) - 1]

# a*b mod 2^61-1‚ð•Ô‚·ŠÖ”(ÅŒã‚ÉMod‚ðŽæ‚é)
proc multRaw(T:typedesc[FastRollingHashOp], a, b:uint):uint =
  let
    au = a shr 31
    ad = a and T.MASK31
    bu = b shr 31
    bd = b and T.MASK31
    mid = ad * bu + au * bd
    midu = mid shr 30
    midd = mid and T.MASK30
  return au * bu * 2 + midu + (midd shl 31) + ad * bd

# mod 2^61-1‚ðŒvŽZ‚·‚éŠÖ”
proc calcMod(T:typedesc[FastRollingHashOp], x:uint):uint =
  let
    xu = x shr 61
    xd = x and T.MASK61
  result = xu + xd
  if result >= T.MOD: result -= T.MOD

proc mult(T:typedesc[FastRollingHashOp], a, b:uint):uint =
  return T.calcMod(T.multRaw(a, b))
# }}}

type RollingHash[T] = object
  hashed, power: seq[uint]

proc initRollingHashCustom[T](s:string, base = 10007'u):RollingHash[T] =
  var
    sz = s.len
    hashed = newSeqWith(sz + 1, 0'u)
    power = newSeqWith(sz + 1, 0'u)
  power[0] = 1'u
  for i in 0..<sz:
    power[i + 1] = T.mult(power[i], base)
    hashed[i + 1] = T.calcMod(T.multRaw(hashed[i], base) + uint(s[i].ord))
#    if hashed[i + 1] >= MOD: hashed[i + 1] -= MOD
  return RollingHash[T](hashed: hashed, power: power)

proc initRollingHash(s:string):auto = initRollingHashCustom[FastRollingHashOp](s)

proc get[T](self: RollingHash[T]; s:Slice[int]):uint =
  result = self.hashed[s.b+1] + T.MOD * 4'u - T.mul(self.hashed[s.a], self.power[s.b-s.a+1])
  if result >= T.MOD: result -= T.MOD

proc connect[T](self: RollingHash[T]; h1, h2:uint, h2len:int):uint =
  result = T.mul(h1, self.power[h2len]) + h2
  if result >= T.MOD: result -= T.MOD

proc LCP[T](self, b:RollingHash[T]; l1, r1, l2, r2:int):int =
  var
    len = min(r1 - l1, r2 - l2)
    low = -1
    high = len + 1
  while high - low > 1:
    let mid = (low + high) div 2
    if self.get(l1..<l1 + mid) == b.get(l2..<l2 + mid): low = mid
    else: high = mid
  return low

#var lh_slow = initRollingHashCustom[RollingHashOp[1000000007]]("abracadabra")
#var lh_fast = initRollingHashCustom[FastRollingHashOp]("abracadabra")
#var lh = initRollingHash("abracadabra")
# }}}

type op = FastRollingHashOp
let p = 100007'u

proc solve(N:int, S:string) =
  var
    l = 0
    f = newSeq[uint]()
    t = newSeq[uint]()
    ans = 0
  for i in 0..<N+1:
    f.add(0)
  while true:
    if f.len == 1:
      break
    t.setlen(0)
    l += 1
    for i in 0..<f.len - 1:
      t.add(op.calcMod(op.mult(f[i].uint, p) + ord(S[i+l-1]).uint))
#    echo t
    var
      a = initTable[uint,int]()
      found = false
    for i in 0..<t.len:
      if t[i] notin a:
        a[t[i]] = i
      else:
        let j = a[t[i]]
        if i - j >= l:
          found = true
    if found: ans = l
    swap(f,t)
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
#}}}
