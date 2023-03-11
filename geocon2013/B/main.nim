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
#}}}

var N:int
var X:seq[int]
var Y:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  X = newSeqWith(N, 0)
  Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
#}}}

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

proc eq(a,b:float):bool = system.`<`(abs(a - b), EPS)
proc ne(a,b:float):bool = system.`>`(abs(a - b), EPS)
proc lt(a,b:float):bool = system.`<`(a + EPS, b)
proc gt(a,b:float):bool = system.`>`(a, b + EPS)
proc le(a,b:float):bool = system.`<`(a, b + EPS)
proc ge(a,b:float):bool = system.`>`(a + EPS, b)
# }}}

# comparison functions {{{
#proc eq(a,b:Real):bool = return abs(b - a) < EPS
proc eq(a,b:Point):bool =
  return eq(a.re, b.re) and eq(a.im, b.im)
#  return system.`<`(abs(b - a), EPS)
proc lt(a,b:Point):bool =
  if ne(a.re, b.re): return lt(a.re, b.re)
  elif ne(a.im, b.im): return lt(a.im, b.im)
  return false
proc le(a,b:Point):bool =
  if ne(a.re, b.re): return lt(a.re, b.re)
  elif ne(a.im, b.im): return lt(a.im, b.im)
  return true
# }}}

# Line and Segment {{{
type Line = object
  a, b:Point

type Segment {.borrow: `.`.} = distinct Line

proc initLine(a,b:Point):Line = Line(a:a, b:b)
proc initLine(A, B, C:Real):Line = # Ax + By = C
  var a, b: Point
  if A == 0.Real: a = initPoint(0.Real, C / B); b = initPoint(1.Real, C / B)
  elif B == 0.Real: b = initPoint(C / A, 0.Real); b = initPoint(C / A, 1.Real)
  else: a = initPoint(0.Real, C / B); b = initPoint(C / A, 0.Real)
  return initLine(a, b)

proc `$`(p:Line):string =
  return(p.a.toString & " to " & p.b.toString)
proc nextLine():Line = initLine(nextPoint(), nextPoint())

proc initSegment(a, b:Point):Segment = Segment(Line(a:a, b:b))
proc nextSegment():Segment = initSegment(nextPoint(), nextPoint())
# }}}

# Circle {{{
type Circle = object
  p:Point
  r:Real

proc initCircle(p:Point, r:Real):Circle = Circle(p:p, r:r)
# }}}

proc cross(a,b:Point):Real = a.re * b.im - a.im * b.re
proc dot(a,b:Point):Real = a.re * b.re + a.im * b.im

proc norm(a:Point):Real = dot(a,a)

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_C
proc ccw(a, b, c: Point):int =
  var
    b = b - a
    c = c - a
  if cross(b, c).gt(0.Real): return +1  # "COUNTER_CLOCKWISE"
  if cross(b, c).lt(-0.Real): return -1 # "CLOCKWISE"
  if dot(b, c).lt(0): return +2      # "ONLINE_BACK" c-a-b
  if norm(b).lt(norm(c)): return -2  # "ONLINE_FRONT" a-b-c
  return 0                         # "ON_SEGMENT" a-c-b

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_A
proc parallel(a,b:Line):bool = cross(a.b - a.a, b.b - b.a).eq(0.Real)
# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_A
proc orthogonal(a,b:Line):bool = dot(a.a - a.b, b.a - b.b).eq(0.Real)

# projection reflection {{{
# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_A
proc projection(p:Point, l:Line):Point =
  let t = dot(p - l.a, l.a - l.b) / norm(l.a - l.b)
  return l.a + (l.a - l.b) * complex(t)
proc projection(p:Point, l:Segment):Point =
  let t = dot(p - l.a, l.a - l.b) / norm(l.a - l.b)
  return l.a + (l.a - l.b) * complex(t)
# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_B
proc reflection(p:Point, l:Line):Point = return p + (p.projection(l) - p) * complex(2.0)
# }}}

# intersect function {{{
proc intersect(l:Line, p:Point):bool = abs(ccw(l.a, l.b, p)) != 1
proc intersect(l,m: Line):bool = abs(cross(l.b - l.a, m.b - m.a)).gt(0.Real) or abs(cross(l.b - l.a, m.b - l.a)).lt(0.Real)

proc intersect(s:Segment, p:Point):bool =
  ccw(s.a, s.b, p) == 0
proc intersect(l:Line, s:Segment):bool =
  (cross(l.b - l.a, s.a - l.a) * cross(l.b - l.a, s.b - l.a)).lt(0.Real)

proc distance(l:Line, p:Point):Real
proc intersect(c:Circle, l:Line):bool = distance(l, c.p) <= c.r

proc intersect(c:Circle, p:Point): bool = abs(abs(p - c.p) - c.r) < 0.Real

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_B
proc intersect(s, t: Segment):bool =
  return ccw(s.a, s.b, t.a) * ccw(s.a, s.b, t.b) <= 0 and ccw(t.a, t.b, s.a) * ccw(t.a, t.b, s.b) <= 0

proc intersect(c:Circle, l:Segment):int =
  if (norm(c.p.projection(l) - c.p) - c.r * c.r).gt 0.Real: return 0
  let
    d1 = abs(c.p - l.a)
    d2 = abs(c.p - l.b)
  if d1.le(c.r) and d2.le(c.r): return 0
  if d1.lt(c.r) and d2.gt(c.r) or d1.gt(c.r) and d2.lt(c.r): return 1
  let h:Point = c.p.projection(l)
  if dot(l.a - h, l.b - h).lt(0.Real): return 2
  return 0

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_A
# number of common tangent
proc intersect(c1, c2: Circle):int =
  var (c1, c2) = (c1, c2)
  if c1.r.lt c2.r: swap(c1, c2)
  let d = abs(c1.p - c2.p)
  if(c1.r + c2.r).lt d: return 4
  if(c1.r + c2.r).eq d: return 3
  if(c1.r - c2.r).lt d: return 2
  if(c1.r - c2.r).eq d: return 1
  return 0
# }}}

# distance function {{{
proc distance(a, b:Point):Real = abs(a - b)
proc distance(l:Line, p:Point):Real = abs(p - p.projection(l))
proc distance(l, m: Line):Real = (if intersect(l, m): 0.Real else: distance(l, m.a))

proc distance(s:Segment, p:Point):Real =
  let r = p.projection(s)
  if intersect(s, r): return abs(r - p)
  return min(abs(s.a - p), abs(s.b - p))

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_D
proc distance(a, b:Segment):Real =
  if intersect(a, b): return 0
  return min(min(distance(a, b.a), distance(a, b.b)), min(distance(b, a.a), distance(b, a.b)))
proc distance(l:Line, s:Segment):Real =
  if intersect(l, s): return 0
  return min(distance(l, s.a), distance(l, s.b));
# }}}

# crosspoint function {{{
proc crosspoint(l,m:Line):Point =
  let
    A = cross(l.b - l.a, m.b - m.a)
    B = cross(l.b - l.a, l.b - m.a)
  if abs(A) == 0.Real and abs(B) == 0.Real: return m.a
  return m.a + (m.b - m.a) * complex(B) / A

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_C
proc crosspoint(l,m:Segment):Point =
  return crosspoint(Line(l), Line(m));

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_D
proc crosspoint(c:Circle, l:Line):(Point,Point) =
  let pr = c.p.projection(l)
  let e = (l.b - l.a) / abs(l.b - l.a)
  if distance(l, c.p) == c.r: return (pr, pr)
  let base = sqrt(c.r * c.r - norm(pr - c.p))
  return (pr - e * complex(base), pr + e * complex(base))

proc crosspoint(c:Circle, l:Segment):(Point,Point) =
  let
    aa = cast[Line](l)
  if intersect(c, l) == 2: return crosspoint(c, aa)
  result = crosspoint(c, aa)
  if dot(l.a - result[0], l.b - result[0]) < 0: result[1] = result[0]
  else: result[0] = result[1]

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_E
proc crosspoint(c1, c2: Circle):(Point,Point) =
  let
    d = abs(c1.p - c2.p)
    a = arccos((c1.r * c1.r + d * d - c2.r * c2.r) / (2 * c1.r * d))
    t = arctan2(c2.p.im - c1.p.im, c2.p.re - c1.p.re)
  return (c1.p + initPoint(cos(t + a) * c1.r, sin(t + a) * c1.r),
          c1.p + initPoint(cos(t - a) * c1.r, sin(t - a) * c1.r))
# }}}

proc main() =
  p := initPoint(1.0, 2.0)
  echo p + p
  return

main()
