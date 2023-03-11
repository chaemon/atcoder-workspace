const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/li_chao_tree
#import lib/math/longdouble
#import rationals

import BigNum
converter toBitInt(a:int):Int = newInt(a)

const DO_REDUCE = true

# {{{
import math, hashes

type Rational*[T] = object
  ## A rational number, consisting of a numerator `num` and a denominator `den`.
  num*, den*: T
template reduce*[T](x: var Rational[T]) =
  ## Reduces the rational number `x`, so that the numerator and denominator
  ## have no common divisors other than 1 (and -1).
  ## If `x` is 0, raises `DivByZeroDefect`.
  ##
  ## **Note:** This is called automatically by the various operations on rationals.
  when DO_REDUCE:
    if x.den == 0:
      if x.num > 0: x.num = T(1)
      elif x.num < 0: x.num = T(-1)
      else:
        discard
        #assert false # 不定
    else:
      let common = gcd(x.num, x.den)
      if x.den > 0:
        x.num = x.num div common
        x.den = x.den div common
      else:
        x.num = -x.num div common
        x.den = -x.den div common
        #raise newException(DivByZeroDefect, "division by zero")

func initRational*[T](num, den: T): Rational[T] =
  ## Creates a new rational number with numerator `num` and denominator `den`.
  ## `den` must not be 0.
  ##
  ## **Note:** `den != 0` is not checked when assertions are turned off.
  #assert(den != 0, "a denominator of zero is invalid")
  result.num = num
  result.den = den
  reduce(result)

func `/-`*[T](num, den: T): Rational[T] =
  ## A friendlier version of `initRational <#initRational,T,T>`_.
  initRational[T](num, den)

func `$`*[T](x: Rational[T]): string =
  ## Turns a rational number into a string.
  result = $x.num & "/" & $x.den

func toRational*[T](x: T): Rational[T] =
  ## Converts some integer `x` to a rational number.
  result.num = x
  result.den = 1

func toRational*(x: float,
                 n: int = high(int) shr (sizeof(int) div 2 * 8)): Rational[int] =
  ## Calculates the best rational approximation of `x`,
  ## where the denominator is smaller than `n`
  ## (default is the largest possible `int` for maximal resolution).
  ##
  ## The algorithm is based on the theory of continued fractions.
  # David Eppstein / UC Irvine / 8 Aug 1993
  # With corrections from Arno Formella, May 2008

  var
    m11, m22 = 1
    m12, m21 = 0
    ai = int(x)
    x = x
  while m21 * ai + m22 <= n:
    swap m12, m11
    swap m22, m21
    m11 = m12 * ai + m11
    m21 = m22 * ai + m21
    if x == float(ai): break # division by zero
    x = 1 / (x - float(ai))
    if x > float(high(int32)): break # representation failure
    ai = int(x)
  result = initRational[int](m11, m21)

func toFloat*[T](x: Rational[T]): float =
  ## Converts a rational number `x` to a `float`.
  x.num / x.den

func toInt*[T](x: Rational[T]): int =
  ## Converts a rational number `x` to an `int`. Conversion rounds towards 0 if
  ## `x` does not contain an integer value.
  x.num div x.den

func `+`*[T](x, y: Rational[T]): Rational[T] =
  ## Adds two rational numbers.
  #let common = lcm(x.den, y.den)
  #result.num = common div x.den * x.num + common div y.den * y.num
  #result.den = common

  result.num = x.num * y.den + y.num * x.den
  result.den = x.den * y.den
  reduce(result)


func `+`*[T](x: Rational[T], y: T): Rational[T] =
  ## Adds the rational `x` to the int `y`.
  result.num = x.num + y * x.den
  result.den = x.den

func `+`*[T](x: T, y: Rational[T]): Rational[T] =
  ## Adds the int `x` to the rational `y`.
  result.num = x * y.den + y.num
  result.den = y.den

func `+=`*[T](x: var Rational[T], y: Rational[T]) =
  ## Adds the rational `y` to the rational `x` in-place.
  #let common = lcm(x.den, y.den)
  #x.num = common div x.den * x.num + common div y.den * y.num
  #x.den = common
  x.num = x.num * y.den + y.num * x.den
  x.den *= y.den

  reduce(x)

func `+=`*[T](x: var Rational[T], y: T) =
  ## Adds the int `y` to the rational `x` in-place.
  x.num += y * x.den

func `-`*[T](x: Rational[T]): Rational[T] =
  ## Unary minus for rational numbers.
  result.num = -x.num
  result.den = x.den

func `-`*[T](x, y: Rational[T]): Rational[T] =
  ## Subtracts two rational numbers.
  #let common = lcm(x.den, y.den)
  #result.num = common div x.den * x.num - common div y.den * y.num
  #result.den = common
  result.num = x.num * y.den - y.num * x.den
  result.den = x.den * y.den
  reduce(result)

func `-`*[T](x: Rational[T], y: T): Rational[T] =
  ## Subtracts the int `y` from the rational `x`.
  result.num = x.num - y * x.den
  result.den = x.den

func `-`*[T](x: T, y: Rational[T]): Rational[T] =
  ## Subtracts the rational `y` from the int `x`.
  result.num = x * y.den - y.num
  result.den = y.den

func `-=`*[T](x: var Rational[T], y: Rational[T]) =
  ## Subtracts the rational `y` from the rational `x` in-place.
  #let common = lcm(x.den, y.den)
  #x.num = common div x.den * x.num - common div y.den * y.num
  #x.den = common
  x.num = x.num * y.den - y.num * x.den
  x.den *= y.den
  reduce(x)

func `-=`*[T](x: var Rational[T], y: T) =
  ## Subtracts the int `y` from the rational `x` in-place.
  x.num -= y * x.den

func `*`*[T](x, y: Rational[T]): Rational[T] =
  ## Multiplies two rational numbers.
  result.num = x.num * y.num
  result.den = x.den * y.den
  reduce(result)

func `*`*[T](x: Rational[T], y: T): Rational[T] =
  ## Multiplies the rational `x` with the int `y`.
  result.num = x.num * y
  result.den = x.den
  reduce(result)

func `*`*[T](x: T, y: Rational[T]): Rational[T] =
  ## Multiplies the int `x` with the rational `y`.
  result.num = x * y.num
  result.den = y.den
  reduce(result)

func `*=`*[T](x: var Rational[T], y: Rational[T]) =
  ## Multiplies the rational `x` by `y` in-place.
  x.num *= y.num
  x.den *= y.den
  reduce(x)

func `*=`*[T](x: var Rational[T], y: T) =
  ## Multiplies the rational `x` by the int `y` in-place.
  x.num *= y
  reduce(x)

func reciprocal*[T](x: Rational[T]): Rational[T] =
  ## Calculates the reciprocal of `x` (`1/x`).
  ## If `x` is 0, raises `DivByZeroDefect`.
  if x.num > 0:
    result.num = x.den
    result.den = x.num
  elif x.num < 0:
    result.num = -x.den
    result.den = -x.num
  else:
    raise newException(DivByZeroDefect, "division by zero")

func `/`*[T](x, y: Rational[T]): Rational[T] =
  ## Divides the rational `x` by the rational `y`.
  result.num = x.num * y.den
  result.den = x.den * y.num
  reduce(result)

func `/`*[T](x: Rational[T], y: T): Rational[T] =
  ## Divides the rational `x` by the int `y`.
  result.num = x.num
  result.den = x.den * y
  reduce(result)

func `/`*[T](x: T, y: Rational[T]): Rational[T] =
  ## Divides the int `x` by the rational `y`.
  result.num = x * y.den
  result.den = y.num
  reduce(result)

func `/=`*[T](x: var Rational[T], y: Rational[T]) =
  ## Divides the rational `x` by the rational `y` in-place.
  x.num *= y.den
  x.den *= y.num
  reduce(x)

func `/=`*[T](x: var Rational[T], y: T) =
  ## Divides the rational `x` by the int `y` in-place.
  x.den *= y
  reduce(x)

func cmp*(x, y: Rational): int =
  ## Compares two rationals. Returns
  ## * a value less than zero, if `x < y`
  ## * a value greater than zero, if `x > y`
  ## * zero, if `x == y`
  if x < y: return -1
  elif x > y: return 1
  else: return 0
  #(x - y).num

func `<`*(x, y: Rational): bool =
  ## Returns true if `x` is less than `y`.
  (x - y).num < Rational.T(0)

func `<=`*(x, y: Rational): bool =
  ## Returns tue if `x` is less than or equal to `y`.
  (x - y).num <= 0

func `==`*(x, y: Rational): bool =
  ## Compares two rationals for equality.
  (x - y).num == 0

func abs*[T](x: Rational[T]): Rational[T] =
  ## Returns the absolute value of `x`.
  runnableExamples:
    doAssert abs(1 // 2) == 1 // 2
    doAssert abs(-1 // 2) == 1 // 2

  result.num = abs x.num
  result.den = abs x.den

func `div`*[T](x, y: Rational[T]): T =
  ## Computes the rational truncated division.
  (x.num * y.den) div (y.num * x.den)

func `mod`*[T](x, y: Rational[T]): Rational[T] =
  ## Computes the rational modulo by truncated division (remainder).
  ## This is same as `x - (x div y) * y`.
  result = ((x.num * y.den) mod (y.num * x.den)) // (x.den * y.den)
  reduce(result)

func floorDiv*[T](x, y: Rational[T]): T =
  ## Computes the rational floor division.
  ##
  ## Floor division is conceptually defined as `floor(x / y)`.
  ## This is different from the `div` operator, which is defined
  ## as `trunc(x / y)`. That is, `div` rounds towards 0 and `floorDiv`
  ## rounds down.
  floorDiv(x.num * y.den, y.num * x.den)

func floorMod*[T](x, y: Rational[T]): Rational[T] =
  ## Computes the rational modulo by floor division (modulo).
  ##
  ## This is same as `x - floorDiv(x, y) * y`.
  ## This func behaves the same as the `%` operator in Python.
  result = floorMod(x.num * y.den, y.num * x.den) // (x.den * y.den)
  reduce(result)

func hash*[T](x: Rational[T]): Hash =
  ## Computes the hash for the rational `x`.
  # reduce first so that hash(x) == hash(y) for x == y
  var copy = x
  reduce(copy)

  var h: Hash = 0
  h = h !& hash(copy.num)
  h = h !& hash(copy.den)
  result = !$h
# }}}


converter toRational(a:int):Rational[int] =
  initRational(a, 1)

converter toRational2(a:int):Rational[Int] =
  initRational[Int](a, 1)

solveProc solve(Q:int, X:seq[int], Y:seq[int], A:seq[int], B:seq[int]):
  type T = Rational[Int]
  var qxi = newSeqWith(Q, -1)
  var xs = newSeq[T]()
  # X[i] + Y[i] * (B[i] / A[i])を考える
  var v = newSeq[tuple[x:Rational[Int], i:int]]()
  for i in Q:
    if A[i] != 0:
      let p = initRational(newInt(B[i]), newInt(A[i]))
      v.add((p, i))
  v.sort()
  for i in v.len:
    xs.add(v[i].x)
    qxi[v[i].i] = i
  let infRational = initRational[Int](1, 0)
  var pmin, pmax = initLiChaoTree[T](xs, infRational)
  var 
    Ymin = int.inf
    Ymax = -int.inf
  for i in Q:
    pmin.update(initRational[Int](Y[i], 1), initRational[Int](X[i], 1))
    pmax.update(-initRational[Int](Y[i], 1), -initRational[Int](X[i], 1))
    Ymin.min=Y[i]
    Ymax.max=Y[i]
    if qxi[i] != -1:
      if A[i] > 0:
        echo (-A[i].Int * pmax.query(qxi[i])).num
      else:
        echo (A[i].Int * pmin.query(qxi[i])).num
    else:
      if B[i] > 0:
        echo Ymax * B[i]
      else:
        echo Ymin * B[i]
  echo "Hello World"
  discard

when not DO_TEST:
  var Q = nextInt()
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextInt()
    Y[i] = nextInt()
    A[i] = nextInt()
    B[i] = nextInt()
  solve(Q, X, Y, A, B)
else:
  discard

