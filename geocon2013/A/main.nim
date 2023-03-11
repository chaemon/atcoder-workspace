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
    if int(c) > int(' '):
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
print = proc(x: varargs[string, toStr]) = discard print0(@x, sep = " ")

#{{{ complex class
{.push checks: off, line_dir: off, stack_trace: off, debugger: off.}
# the user does not want to trace a part of the standard library!

import math

type
  Complex* = object
    re*, im*: float

proc complex*(re: float; im: float = 0.0): Complex =
  result.re = re
  result.im = im

template im*(arg: typedesc[float]): Complex = complex(0, 1)
template im*(arg: float): Complex = complex(0, arg)

proc abs*(z: Complex): float =
  ## Return the distance from (0,0) to ``z``.
  result = hypot(z.re, z.im)

proc abs2*(z: Complex): float =
  ## Return the squared distance from (0,0) to ``z``.
  result = z.re*z.re + z.im*z.im

proc conjugate*(z: Complex): Complex =
  ## Conjugate of complex number ``z``.
  result.re = z.re
  result.im = -z.im

proc `==` *(x, y: Complex): bool =
  ## Compare two complex numbers ``x`` and ``y`` for equality.
  result = x.re == y.re and x.im == y.im

#proc `+` *(x: float; y: Complex): Complex =
#  ## Add a real number to a complex number.
#  result.re = x + y.re
#  result.im = y.im

proc `+` *(x: Complex; y: float): Complex =
  ## Add a complex number to a real number.
  result.re = x.re + y
  result.im = x.im

proc `+` *(x, y: Complex): Complex =
  ## Add two complex numbers.
  result.re = x.re + y.re
  result.im = x.im + y.im

proc `-` *(z: Complex): Complex =
  ## Unary minus for complex numbers.
  result.re = -z.re
  result.im = -z.im

#proc `-` *(x: float; y: Complex): Complex =
#  ## Subtract a complex number from a real number.
#  x + (-y)

proc `-` *(x: Complex; y: float): Complex =
  ## Subtract a real number from a complex number.
  result.re = x.re - y
  result.im = x.im

proc `-` *(x, y: Complex): Complex =
  ## Subtract two complex numbers.
  result.re = x.re - y.re
  result.im = x.im - y.im

proc `*` *(x, y: Complex): Complex =
  ## Multiply ``x`` with ``y``.
  result.re = x.re * y.re - x.im * y.im
  result.im = x.im * y.re + x.re * y.im

#proc `*` *(x: float; y: Complex): Complex =
#  ## Multiply a real number and a complex number.
#  result.re = x * y.re
#  result.im = x * y.im

proc `*` *(x: Complex; y: float): Complex =
  ## Multiply a complex number with a real number.
  result.re = x.re * y
  result.im = x.im * y

proc `/` *(x: Complex; y: float): Complex =
  ## Divide complex number ``x`` by real number ``y``.
  result.re = x.re / y
  result.im = x.im / y

proc inv*(z: Complex): Complex =
  ## Multiplicative inverse of complex number ``z``.
  conjugate(z) / abs2(z)

#proc `/` *(x: float; y: Complex): Complex =
#  ## Divide real number ``x`` by complex number ``y``.
#  result = x * inv(y)

proc `/` *(x, y: Complex): Complex =
  ## Divide ``x`` by ``y``.
  var r, den: float
  if abs(y.re) < abs(y.im):
    r = y.re / y.im
    den = y.im + r * y.re
    result.re = (x.re * r + x.im) / den
    result.im = (x.im * r - x.re) / den
  else:
    r = y.im / y.re
    den = y.re + r * y.im
    result.re = (x.re + r * x.im) / den
    result.im = (x.im - r * x.re) / den

proc `+=` *(x: var Complex; y: Complex) =
  ## Add ``y`` to ``x``.
  x.re += y.re
  x.im += y.im

proc `-=` *(x: var Complex; y: Complex) =
  ## Subtract ``y`` from ``x``.
  x.re -= y.re
  x.im -= y.im

proc `*=` *(x: var Complex; y: Complex) =
  ## Multiply ``y`` to ``x``.
  let im = x.im * y.re + x.re * y.im
  x.re = x.re * y.re - x.im * y.im
  x.im = im

proc `/=` *(x: var Complex; y: Complex) =
  ## Divide ``x`` by ``y`` in place.
  x = x / y


proc sqrt*(z: Complex): Complex =
  ## Square root for a complex number ``z``.
  var x, y, w, r: float

  if z.re == 0.0 and z.im == 0.0:
    result = z
  else:
    x = abs(z.re)
    y = abs(z.im)
    if x >= y:
      r = y / x
      w = sqrt(x) * sqrt(0.5 * (1.0 + sqrt(1.0 + r * r)))
    else:
      r = x / y
      w = sqrt(y) * sqrt(0.5 * (r + sqrt(1.0 + r * r)))

    if z.re >= 0.0:
      result.re = w
      result.im = z.im / (w * 2.0)
    else:
      result.im = if z.im >= 0.0: w else: -w
      result.re = z.im / (result.im + result.im)

proc exp*(z: Complex): Complex =
  ## ``e`` raised to the power ``z``.
  var
    rho = exp(z.re)
    theta = z.im
  result.re = rho * cos(theta)
  result.im = rho * sin(theta)

proc ln*(z: Complex): Complex =
  ## Returns the natural log of ``z``.
  result.re = ln(abs(z))
  result.im = arctan2(z.im, z.re)

proc log10*(z: Complex): Complex =
  ## Returns the log base 10 of ``z``.
  result = ln(z) / ln(10.0)

proc log2*(z: Complex): Complex =
  ## Returns the log base 2 of ``z``.
  result = ln(z) / ln(2.0)

proc pow*(x, y: Complex): Complex =
  ## ``x`` raised to the power ``y``.
  if x.re == 0.0 and x.im == 0.0:
    if y.re == 0.0 and y.im == 0.0:
      result.re = 1.0
      result.im = 0.0
    else:
      result.re = 0.0
      result.im = 0.0
  elif y.re == 1.0 and y.im == 0.0:
    result = x
  elif y.re == -1.0 and y.im == 0.0:
    result = complex(1.0) / x
  else:
    var
      rho = abs(x)
      theta = arctan2(x.im, x.re)
      s = pow(rho, y.re) * exp(-y.im * theta)
      r = y.re * theta + y.im * ln(rho)
    result.re = s * cos(r)
    result.im = s * sin(r)

proc pow*(x: Complex; y: float): Complex =
  ## Complex number ``x`` raised to the power ``y``.
  pow(x, complex(y))


proc sin*(z: Complex): Complex =
  ## Returns the sine of ``z``.
  result.re = sin(z.re) * cosh(z.im)
  result.im = cos(z.re) * sinh(z.im)

proc arcsin*(z: Complex): Complex =
  ## Returns the inverse sine of ``z``.
  result = -im(float) * ln(im(float) * z + sqrt(complex(1.0) - z*z))

proc cos*(z: Complex): Complex =
  ## Returns the cosine of ``z``.
  result.re = cos(z.re) * cosh(z.im)
  result.im = -sin(z.re) * sinh(z.im)

proc arccos*(z: Complex): Complex =
  ## Returns the inverse cosine of ``z``.
  result = -im(float) * ln(z + sqrt(z*z - float(1.0)))

proc tan*(z: Complex): Complex =
  ## Returns the tangent of ``z``.
  result = sin(z) / cos(z)

proc arctan*(z: Complex): Complex =
  ## Returns the inverse tangent of ``z``.
  result = complex(0.5)*im(float) * (ln(complex(1.0) - im(float)*z) - ln(complex(1.0) + im(float)*z))

proc cot*(z: Complex): Complex =
  ## Returns the cotangent of ``z``.
  result = cos(z)/sin(z)

proc arccot*(z: Complex): Complex =
  ## Returns the inverse cotangent of ``z``.
  result = complex(0.5)*im(float) * (ln(complex(1.0) - im(float)/z) - ln(complex(1.0) + im(float)/z))

proc sec*(z: Complex): Complex =
  ## Returns the secant of ``z``.
  result = complex(1.0) / cos(z)

proc arcsec*(z: Complex): Complex =
  ## Returns the inverse secant of ``z``.
  result = -im(float) * ln(im(float) * sqrt(complex(1.0) - complex(1.0)/(z*z)) + complex(1.0)/z)

proc csc*(z: Complex): Complex =
  ## Returns the cosecant of ``z``.
  result = complex(1.0) / sin(z)

proc arccsc*(z: Complex): Complex =
  ## Returns the inverse cosecant of ``z``.
  result = -im(float) * ln(sqrt(complex(1.0) - complex(1.0)/(z*z)) + im(float)/z)

proc sinh*(z: Complex): Complex =
  ## Returns the hyperbolic sine of ``z``.
  result = complex(0.5) * (exp(z) - exp(-z))

proc arcsinh*(z: Complex): Complex =
  ## Returns the inverse hyperbolic sine of ``z``.
  result = ln(z + sqrt(z*z + 1.0))

proc cosh*(z: Complex): Complex =
  ## Returns the hyperbolic cosine of ``z``.
  result = complex(0.5) * (exp(z) + exp(-z))

proc arccosh*(z: Complex): Complex =
  ## Returns the inverse hyperbolic cosine of ``z``.
  result = ln(z + sqrt(z*z - float(1.0)))

proc tanh*(z: Complex): Complex =
  ## Returns the hyperbolic tangent of ``z``.
  result = sinh(z) / cosh(z)

proc arctanh*(z: Complex): Complex =
  ## Returns the inverse hyperbolic tangent of ``z``.
  result = complex(0.5) * (ln((complex(1.0)+z) / (complex(1.0)-z)))

proc sech*(z: Complex): Complex =
  ## Returns the hyperbolic secant of ``z``.
  result = complex(2.0) / (exp(z) + exp(-z))

proc arcsech*(z: Complex): Complex =
  ## Returns the inverse hyperbolic secant of ``z``.
  result = ln(1.0.complex/z + sqrt(complex(1.0)/z+float(1.0)) * sqrt(complex(1.0)/z-float(1.0)))

proc csch*(z: Complex): Complex =
  ## Returns the hyperbolic cosecant of ``z``.
  result = complex(2.0) / (exp(z) - exp(-z))

proc arccsch*(z: Complex): Complex =
  ## Returns the inverse hyperbolic cosecant of ``z``.
  result = ln(complex(1.0)/z + sqrt(complex(1.0)/(z*z) + float(1.0)))

proc coth*(z: Complex): Complex =
  ## Returns the hyperbolic cotangent of ``z``.
  result = cosh(z) / sinh(z)

proc arccoth*(z: Complex): Complex =
  ## Returns the inverse hyperbolic cotangent of ``z``.
  result = complex(0.5) * (ln(complex(1.0) + complex(1.0)/z) - ln(complex(1.0) - complex(1.0)/z))

proc phase*(z: Complex): float =
  ## Returns the phase of ``z``.
  arctan2(z.im, z.re)

proc polar*(z: Complex): tuple[r, phi: float] =
  ## Returns ``z`` in polar coordinates.
  (r: abs(z), phi: phase(z))

proc rect*(r, phi: float): Complex =
  ## Returns the complex number with polar coordinates ``r`` and ``phi``.
  ##
  ## | ``result.re = r * cos(phi)``
  ## | ``result.im = r * sin(phi)``
  complex(r * cos(phi), r * sin(phi))


proc `$`*(z: Complex): string =
  ## Returns ``z``'s string representation as ``"(re, im)"``.
  result = "(" & $z.re & ", " & $z.im & ")"

{.pop.}
#}}}

import math
import sets, sequtils

type
  Real = float
  Point = Complex

#let EPS:Real = 1e-8
#  PI = arccos(-1)


proc initPoint(re:float, im:float):Point = Point(re:re, im:im)
proc nextPoint():Point = return initPoint(nextFloat(), nextFloat())

proc `*`(p:Point, d:Real):Point =
  return Point(re:p.re * d, im:p.im * d)

proc toString(p:Point):string = $(p.re) & " " & $(p.im)

# rotate point p counterclockwise by theta rad
proc rotate(theta:Real, p:Point):Point =
  return initPoint(cos(theta) * p.re - sin(theta) * p.im, sin(theta) * p.re + cos(theta) * p.im)

proc radianToDegree(r:Real):Real = r * 180.Real / PI
proc degreeToRadian(d:Real):Real = d * PI / 180.Real

# smaller angle of the a-b-c
proc getAngle(a,b,c:Point):Real =
  let
    v = b - a
    w = c - b
  var
    alpha = arctan2(v.im, v.re)
    beta = arctan2(w.im, w.re)
  if alpha > beta: swap(alpha, beta)
  let theta = beta - alpha
  return min(theta, 2.Real * PI - theta)

# float comp {{{
const EPS = 1e-9

proc `==`(a,b:float):bool = system.`<`(abs(a - b), EPS)
proc `!=`(a,b:float):bool = system.`>`(abs(a - b), EPS)
proc `<`(a,b:float):bool = system.`<`(a + EPS, b)
proc `>`(a,b:float):bool = system.`>`(a, b + EPS)
proc `<=`(a,b:float):bool = system.`<`(a, b + EPS)
proc `>=`(a,b:float):bool = system.`>`(a + EPS, b)
# }}}

# comparison functions {{{
#proc eq(a,b:Real):bool = return abs(b - a) < EPS
proc `==`(a,b:Point):bool =
  return a.re == b.re and a.im == b.im
#  return system.`<`(abs(b - a), EPS)
proc `<`(a,b:Point):bool =
  if a.re != b.re: return a.re < b.re
  elif a.im != b.im: return a.im < b.im
  return false
proc `<=`(a,b:Point):bool =
  if a.re != b.re: return a.re < b.re
  elif a.im != b.im: return a.im < b.im
  return true
# }}}

block main:
  let p = newSeqWith(300, nextPoint())
  var v = newSeq[(Point,int)]()
  for i,p in p: v.add((p, i))
  v.sort()
  print 100
  for i in countup(0, 299, 3):
    print v[i][1] + 1, v[i+1][1] + 1, v[i+1][1] + 1
  discard

