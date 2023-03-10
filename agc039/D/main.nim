#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
{.hints:off checks:off}

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

#{{{ complex
{.push checks: off, line_dir: off, stack_trace: off, debugger: off.}
# the user does not want to trace a part of the standard library!

import math

type
  Complex*[T: float or float32 or float64] = object
    re*, im*: T
    ## A complex number, consisting of a real and an imaginary part.
  Complex64* = Complex[float64]
    ## Alias for a pair of 64-bit floats.
  Complex32* = Complex[float32]
    ## Alias for a pair of 32-bit floats.

proc complex*[T: float or float32 or float64](re: T; im: T = 0.0): Complex[T] =
  result.re = re
  result.im = im

proc complex32*(re: float32; im: float32 = 0.0): Complex[float32] =
  result.re = re
  result.im = im

proc complex64*(re: float64; im: float64 = 0.0): Complex[float64] =
  result.re = re
  result.im = im

template im*(arg: typedesc[float32]): Complex32 = complex[float32](0, 1)
template im*(arg: typedesc[float64]): Complex64 = complex[float64](0, 1)
template im*(arg: float32): Complex32 = complex[float32](0, arg)
template im*(arg: float64): Complex64 = complex[float64](0, arg)

proc abs*[T](z: Complex[T]): T =
  ## Return the distance from (0,0) to ``z``.
  result = hypot(z.re, z.im)

proc abs2*[T](z: Complex[T]): T =
  ## Return the squared distance from (0,0) to ``z``.
  result = z.re*z.re + z.im*z.im

proc conjugate*[T](z: Complex[T]): Complex[T] =
  ## Conjugate of complex number ``z``.
  result.re = z.re
  result.im = -z.im

proc inv*[T](z: Complex[T]): Complex[T] =
  ## Multiplicative inverse of complex number ``z``.
  conjugate(z) / abs2(z)

proc `==` *[T](x, y: Complex[T]): bool =
  ## Compare two complex numbers ``x`` and ``y`` for equality.
  result = x.re == y.re and x.im == y.im

#proc `+` *[T](x: T; y: Complex[T]): Complex[T] =
#  ## Add a real number to a complex number.
#  result.re = x + y.re
#  result.im = y.im
#
#proc `+` *[T](x: Complex[T]; y: T): Complex[T] =
#  ## Add a complex number to a real number.
#  result.re = x.re + y
#  result.im = x.im

proc `+` *[T](x, y: Complex[T]): Complex[T] =
  ## Add two complex numbers.
  result.re = x.re + y.re
  result.im = x.im + y.im

proc `-` *[T](z: Complex[T]): Complex[T] =
  ## Unary minus for complex numbers.
  result.re = -z.re
  result.im = -z.im

#proc `-` *[T](x: T; y: Complex[T]): Complex[T] =
#  ## Subtract a complex number from a real number.
#  x + (-y)
#
#proc `-` *[T](x: Complex[T]; y: T): Complex[T] =
#  ## Subtract a real number from a complex number.
#  result.re = x.re - y
#  result.im = x.im

proc `-` *[T](x, y: Complex[T]): Complex[T] =
  ## Subtract two complex numbers.
  result.re = x.re - y.re
  result.im = x.im - y.im

#proc `/` *[T](x: Complex[T]; y: T): Complex[T] =
#  ## Divide complex number ``x`` by real number ``y``.
#  result.re = x.re / y
#  result.im = x.im / y
#
#proc `/` *[T](x: T; y: Complex[T]): Complex[T] =
#  ## Divide real number ``x`` by complex number ``y``.
#  result = x * inv(y)

proc `/` *[T](x, y: Complex[T]): Complex[T] =
  ## Divide ``x`` by ``y``.
  var r, den: T
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

#proc `*` *[T](x: T; y: Complex[T]): Complex[T] =
#  ## Multiply a real number and a complex number.
#  result.re = x * y.re
#  result.im = x * y.im
#
#proc `*` *[T](x: Complex[T]; y: T): Complex[T] =
#  ## Multiply a complex number with a real number.
#  result.re = x.re * y
#  result.im = x.im * y

proc `*` *[T](x, y: Complex[T]): Complex[T] =
  ## Multiply ``x`` with ``y``.
  result.re = x.re * y.re - x.im * y.im
  result.im = x.im * y.re + x.re * y.im


proc `+=` *[T](x: var Complex[T]; y: Complex[T]) =
  ## Add ``y`` to ``x``.
  x.re += y.re
  x.im += y.im

proc `-=` *[T](x: var Complex[T]; y: Complex[T]) =
  ## Subtract ``y`` from ``x``.
  x.re -= y.re
  x.im -= y.im

proc `*=` *[T](x: var Complex[T]; y: Complex[T]) =
  ## Multiply ``y`` to ``x``.
  let im = x.im * y.re + x.re * y.im
  x.re = x.re * y.re - x.im * y.im
  x.im = im

proc `/=` *[T](x: var Complex[T]; y: Complex[T]) =
  ## Divide ``x`` by ``y`` in place.
  x = x / y


proc sqrt*[T](z: Complex[T]): Complex[T] =
  ## Square root for a complex number ``z``.
  var x, y, w, r: T

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

proc exp*[T](z: Complex[T]): Complex[T] =
  ## ``e`` raised to the power ``z``.
  var
    rho = exp(z.re)
    theta = z.im
  result.re = rho * cos(theta)
  result.im = rho * sin(theta)

proc ln*[T](z: Complex[T]): Complex[T] =
  ## Returns the natural log of ``z``.
  result.re = ln(abs(z))
  result.im = arctan2(z.im, z.re)

proc log10*[T](z: Complex[T]): Complex[T] =
  ## Returns the log base 10 of ``z``.
  result = ln(z) / ln(10.0)

proc log2*[T](z: Complex[T]): Complex[T] =
  ## Returns the log base 2 of ``z``.
  result = ln(z) / ln(2.0)

proc pow*[T](x, y: Complex[T]): Complex[T] =
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
    result = T(1.0) / x
  else:
    var
      rho = abs(x)
      theta = arctan2(x.im, x.re)
      s = pow(rho, y.re) * exp(-y.im * theta)
      r = y.re * theta + y.im * ln(rho)
    result.re = s * cos(r)
    result.im = s * sin(r)

proc pow*[T](x: Complex[T]; y: T): Complex[T] =
  ## Complex number ``x`` raised to the power ``y``.
  pow(x, complex[T](y))


proc sin*[T](z: Complex[T]): Complex[T] =
  ## Returns the sine of ``z``.
  result.re = sin(z.re) * cosh(z.im)
  result.im = cos(z.re) * sinh(z.im)

proc arcsin*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse sine of ``z``.
  result = -im(T) * ln(im(T) * z + sqrt(T(1.0) - z*z))

proc cos*[T](z: Complex[T]): Complex[T] =
  ## Returns the cosine of ``z``.
  result.re = cos(z.re) * cosh(z.im)
  result.im = -sin(z.re) * sinh(z.im)

proc arccos*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse cosine of ``z``.
  result = -im(T) * ln(z + sqrt(z*z - T(1.0)))

proc tan*[T](z: Complex[T]): Complex[T] =
  ## Returns the tangent of ``z``.
  result = sin(z) / cos(z)

proc arctan*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse tangent of ``z``.
  result = T(0.5)*im(T) * (ln(T(1.0) - im(T)*z) - ln(T(1.0) + im(T)*z))

proc cot*[T](z: Complex[T]): Complex[T] =
  ## Returns the cotangent of ``z``.
  result = cos(z)/sin(z)

proc arccot*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse cotangent of ``z``.
  result = T(0.5)*im(T) * (ln(T(1.0) - im(T)/z) - ln(T(1.0) + im(T)/z))

proc sec*[T](z: Complex[T]): Complex[T] =
  ## Returns the secant of ``z``.
  result = T(1.0) / cos(z)

proc arcsec*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse secant of ``z``.
  result = -im(T) * ln(im(T) * sqrt(1.0 - 1.0/(z*z)) + T(1.0)/z)

proc csc*[T](z: Complex[T]): Complex[T] =
  ## Returns the cosecant of ``z``.
  result = T(1.0) / sin(z)

proc arccsc*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse cosecant of ``z``.
  result = -im(T) * ln(sqrt(T(1.0) - T(1.0)/(z*z)) + im(T)/z)

proc sinh*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic sine of ``z``.
  result = T(0.5) * (exp(z) - exp(-z))

proc arcsinh*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic sine of ``z``.
  result = ln(z + sqrt(z*z + 1.0))

proc cosh*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic cosine of ``z``.
  result = T(0.5) * (exp(z) + exp(-z))

proc arccosh*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic cosine of ``z``.
  result = ln(z + sqrt(z*z - T(1.0)))

proc tanh*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic tangent of ``z``.
  result = sinh(z) / cosh(z)

proc arctanh*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic tangent of ``z``.
  result = T(0.5) * (ln((T(1.0)+z) / (T(1.0)-z)))

proc sech*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic secant of ``z``.
  result = T(2.0) / (exp(z) + exp(-z))

proc arcsech*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic secant of ``z``.
  result = ln(1.0/z + sqrt(T(1.0)/z+T(1.0)) * sqrt(T(1.0)/z-T(1.0)))

proc csch*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic cosecant of ``z``.
  result = T(2.0) / (exp(z) - exp(-z))

proc arccsch*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic cosecant of ``z``.
  result = ln(T(1.0)/z + sqrt(T(1.0)/(z*z) + T(1.0)))

proc coth*[T](z: Complex[T]): Complex[T] =
  ## Returns the hyperbolic cotangent of ``z``.
  result = cosh(z) / sinh(z)

proc arccoth*[T](z: Complex[T]): Complex[T] =
  ## Returns the inverse hyperbolic cotangent of ``z``.
  result = T(0.5) * (ln(T(1.0) + T(1.0)/z) - ln(T(1.0) - T(1.0)/z))

proc phase*[T](z: Complex[T]): T =
  ## Returns the phase of ``z``.
  arctan2(z.im, z.re)

proc polar*[T](z: Complex[T]): tuple[r, phi: T] =
  ## Returns ``z`` in polar coordinates.
  (r: abs(z), phi: phase(z))

proc rect*[T](r, phi: T): Complex[T] =
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

let I = complex(0.0,1.0)
let EPS = 1e-10

#proc check_incenter(x,y,z,p:Complex[float]):void =
#  assert(abs(polar((x-y)/(p-y))[1] - polar((p-y)/(z-y))[1]) < EPS)
#  assert(abs(polar((y-z)/(p-z))[1] - polar((p-z)/(x-z))[1]) < EPS)
#  assert(abs(polar((z-x)/(p-x))[1] - polar((p-x)/(y-x))[1]) < EPS)
#proc incenter(x,y,z:Complex[float]): Complex[float] =
#  return (abs(z-y)*x+abs(x-z)*y+abs(y-x)*z)/(abs(z-y)+abs(x-z)+abs(y-x))

proc solve(N:int, L:int, T:seq[int]) =
  var v = newseq[Complex[float]]()
#  for i in 0..<N:
#    let theta = PI*2.0*float(T[i])/float(L)
#    let theta = PI*float(T[i])/float(L) # half!!
#    v.add(complex[float](cos(theta),sin(theta)))
  var ans = complex[float](0.0)
  var ct = 0
  for i in 0..<N:
    let theta = PI * 2.0 * float(T[i])/float(L)
    let x = complex[float](cos(theta),sin(theta))
    v.add(x)
    var s = complex[float](0.0)
    var s_array = newSeq[Complex[float]]()
    for j in i+1..<N:
      if j - i > 1:
        var theta = 0.0
        theta = PI * 2.0 * float(T[j])/float(L)
        let y = complex[float](cos(theta),sin(theta))
        theta = PI * float(T[i] + T[j])/float(L)
        let z = - complex[float](cos(theta),sin(theta))
        let d = s * (x - z) + z * complex[float](float(j - i - 1))
        ans += d
        ct += j - i - 1
      let theta = PI * float(T[j] - T[i])/float(L)
      let p = complex[float](cos(theta), sin(theta))
      s += p
      s_array.add(p)
  let t = N * (N-1) * (N-2) div 6
  ans.re /= float(t)
  ans.im /= float(t)
  echo ans.re, " ", ans.im
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var L = 0
  L = nextInt()
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
  solve(N, L, T);
  return

main()
#}}}
