#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
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


type
  Real = float
  Point = Complex

proc initPoint(re:float, im:float):Point = Point(re:re, im:im)

let
  EPS:Real = 1e-8
#  PI = arccos(-1)

proc eq(a,b:Real):bool = return abs(b - a) < EPS

proc `*`(p:Point, d:Real):Point =
  return Point(re:p.re * d, im:p.im * d)

proc `$`(p:Point):string = "(" & $(p.re) & "," & $(p.im) & ")"

#istream &operator>>(istream &is, Point &p) {
#  Real a, b;
#  is >> a >> b;
#  p = Point(a, b);
#  return is;
#}
#

# rotate point p counterclockwise by theta rad
proc rotate(theta:Real, p:Point):Point =
  return Point(re:cos(theta) * p.re - sin(theta) * p.im, im:sin(theta) * p.re + cos(theta) * p.im)

proc radianToDegree(r:Real):Real = r * 180.0 / PI
proc degreeToRadian(d:Real):Real = d * PI / 180.0

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
  return min(theta, 2 * arccos(-1) - theta)

proc `<`(a,b:Point):bool =
  if a.re != b.re: a.re < b.re else: a.im < b.im

type Line = object
  a, b:Point

type Segment = distinct Line

proc initLine(a,b:Point):Line = Line(a:a, b:b)

proc initLine(A, B, C:Real):Line = # Ax + By = C
  var a, b: Point
  if eq(A, 0.0): a = initPoint(0.0, C / B); b = initPoint(1, C / B)
  elif eq(B, 0): b = initPoint(C / A, 0); b = initPoint(C / A, 1)
  else: a = initPoint(0, C / B); b = initPoint(C / A, 0)
  return initLine(a, b)

#proc `$`(p:Line):string =
#  return $(p.a) & " to " & $(p.b)

#  friend ostream &operator<<(ostream &os, Line &p) {
#    return os << p.a << " to " << p.b;
#  }
#
#  friend istream &operator>>(istream &is, Line &a) {
#    return is >> a.a >> a.b;
#  }
#};


proc initSegment(a, b:Point):Segment = Segment(Line(a:a, b:b))

#struct Segment : Line {
#  Segment() = default;
#
#  Segment(Point a, Point b) : Line(a, b) {}
#};

type
  Circle = object
    p:Point
    r:Real
  Points = seq[Point]
  Polygon = seq[Point]
  Segments = seq[Segment]
  Lines = seq[Line]
  Circles = seq[Circle]

proc initCircle(p:Point, r:Real):Circle = Circle(p:p, r:r)

proc cross(a,b:Point):Real = a.re * b.im - a.im * b.re
proc dot(a,b:Point):Real = a.re * b.re + a.im * b.im

proc norm(a:Point):Real = dot(a,a)

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_C
proc ccw(a, b, c: Point):int =
  var
    b = b - a
    c = c - a
  if cross(b, c) > EPS: return +1  # "COUNTER_CLOCKWISE"
  if cross(b, c) < -EPS: return -1 # "CLOCKWISE"
  if dot(b, c) < 0: return +2      # "ONLINE_BACK" c-a-b
  if norm(b) < norm(c): return -2  # "ONLINE_FRONT" a-b-c
  return 0                         # "ON_SEGMENT" a-c-b

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_A
proc parallel(a,b:Line):bool = eq(cross(a.b - a.a, b.b - b.a), 0.0)

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_A
proc orthogonal(a,b:Line):bool = eq(dot(a.a - a.b, b.a - b.b), 0.0)

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_A
proc projection(l:Line, p:Point):Point =
  let t = dot(p - l.a, l.a - l.b) / norm(l.a - l.b)
  return l.a + (l.a - l.b) * complex(t)

proc projection(l:Segment, p:Point):Point =
  let l = cast[Line](l)
  let t = dot(p - l.a, l.a - l.b) / norm(l.a - l.b)
  return l.a + (l.a - l.b) * complex(t)

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_1_B
proc reflection(l:Line, p:Point):Point = return p + (projection(l, p) - p) * complex(2.0)

proc intersect(l:Line, p:Point):bool = abs(ccw(l.a, l.b, p)) != 1
proc intersect(l,m: Line):bool = abs(cross(l.b - l.a, m.b - m.a)) > EPS or abs(cross(l.b - l.a, m.b - l.a)) < EPS

proc intersect(s:Segment, p:Point):bool =
  let s = cast[Line](s)
  ccw(s.a, s.b, p) == 0

proc intersect(l:Line, s:Segment):bool =
  let s = cast[Line](s)
  cross(l.b - l.a, s.a - l.a) * cross(l.b - l.a, s.b - l.a) < EPS

proc distance(l:Line, p:Point):Real
proc intersect(c:Circle, l:Line):bool = distance(l, c.p) <= c.r + EPS

proc intersect(c:Circle, p:Point): bool = abs(abs(p - c.p) - c.r) < EPS

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_B
proc intersect(s, t: Segment):bool =
  let (s,t) = (cast[Line](s), cast[Line](t))
  return ccw(s.a, s.b, t.a) * ccw(s.a, s.b, t.b) <= 0 and ccw(t.a, t.b, s.a) * ccw(t.a, t.b, s.b) <= 0

proc intersect(c:Circle, l:Segment):int =
  if norm(projection(l, c.p) - c.p) - c.r * c.r > EPS: return 0
  let
    l = cast[Line](l)
    d1 = abs(c.p - l.a)
    d2 = abs(c.p - l.b)
  if d1 < c.r + EPS and d2 < c.r + EPS: return 0
  if d1 < c.r - EPS and d2 > c.r + EPS or d1 > c.r + EPS and d2 < c.r - EPS: return 1
  let h:Point = projection(l, c.p)
  if dot(l.a - h, l.b - h) < 0: return 2
  return 0

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_A&lang=jp
proc intersect(c1, c2: Circle):int =
  var (c1, c2) = (c1, c2)
  if c1.r < c2.r: swap(c1, c2)
  let d = abs(c1.p - c2.p)
  if c1.r + c2.r < d: return 4
  if eq(c1.r + c2.r, d): return 3
  if c1.r - c2.r < d: return 2
  if eq(c1.r - c2.r, d): return 1
  return 0

proc distance(a, b:Point):Real = abs(a - b)
proc distance(l:Line, p:Point):Real = abs(p - projection(l, p))
proc distance(l, m: Line):Real = (if intersect(l, m): 0.0 else: distance(l, m.a))

proc distance(s:Segment, p:Point):Real =
  let r = projection(s, p)
  let s = cast[Line](s)
  if intersect(s, r): return abs(r - p)
  return min(abs(s.a - p), abs(s.b - p))

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_D
proc distance(a, b:Segment):Real =
  if intersect(a, b): return 0
  let (a,b) = (cast[Line](a), cast[Line](b))
  return min(distance(a, b.a), distance(a, b.b), distance(b, a.a), distance(b, a.b))

proc distance(l:Line, s:Segment):Real =
  if intersect(l, s): return 0
  let s = cast[Line](s)
  return min(distance(l, s.a), distance(l, s.b));

proc crosspoint(l,m:Line):Point =
  let
    A = cross(l.b - l.a, m.b - m.a)
    B = cross(l.b - l.a, l.b - m.a)
  if eq(abs(A), 0.0) and eq(abs(B), 0.0): return m.a
  return m.a + (m.b - m.a) * complex(B) / A

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_2_C
proc crosspoint(l,m:Segment):Point =
  return crosspoint(Line(l), Line(m));

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_D
proc crosspoint(c:Circle, l:Line):(Point,Point) =
  let pr = projection(l, c.p)
  let e = (l.b - l.a) / abs(l.b - l.a)
  if eq(distance(l, c.p), c.r): return (pr, pr)
  let base = sqrt(c.r * c.r - norm(pr - c.p))
  return (pr - e * complex(base), pr + e * complex(base))

proc crosspoint(c:Circle, l:Segment):(Point,Point) =
  let
    aa = cast[Line](l)
  if intersect(c, l) == 2: return crosspoint(c, aa)
  result = crosspoint(c, aa)
  if dot(cast[Line](l).a - result[0], cast[Line](l).b - result[0]) < 0: result[1] = result[0]
  else: result[0] = result[1]

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_E
proc crosspoint(c1, c2: Circle):(Point,Point) =
  let
    d = abs(c1.p - c2.p)
    a = arccos((c1.r * c1.r + d * d - c2.r * c2.r) / (2 * c1.r * d))
    t = arctan2(c2.p.im - c1.p.im, c2.p.re - c1.p.re)
  return (c1.p + initPoint(cos(t + a) * c1.r, sin(t + a) * c1.r),
          c1.p + initPoint(cos(t - a) * c1.r, sin(t - a) * c1.r))

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_F
# tangent of circle c through point p
proc tangent(c1: Circle, p2:Point):(Point, Point) =
  return crosspoint(c1, initCircle(p2, sqrt(norm(c1.p - p2) - c1.r * c1.r)))

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_7_G
# common tangent of circles c1 and c2
proc tangent(c1, c2: Circle):Lines =
  result = newSeq[Line]()
  var (c1, c2) = (c1, c2)
  if c1.r < c2.r: swap(c1, c2)
  let g = norm(c1.p - c2.p)
  if eq(g, 0): return
  let
    u = (c2.p - c1.p) / sqrt(g)
    v = rotate(PI * 0.5, u)
  for s in [-1, 1]:
    let h = (c1.r + s.float * c2.r) / sqrt(g)
    if eq(1 - h * h, 0):
      result.add(initLine(c1.p + u * c1.r.complex, c1.p + (u + v) * c1.r.complex))
    elif 1 - h * h > 0:
      let
        uu = u * h.complex
        vv = v * sqrt(1 - h * h).complex
      result.add(initLine(c1.p + (uu + vv) * c1.r.complex, c2.p - (uu + vv) * c2.r.complex * s.float.complex))
      result.add(initLine(c1.p + (uu - vv) * c1.r.complex, c2.p - (uu - vv) * c2.r.complex * s.float.complex))

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_3_B
proc isConvex(p:Polygon):bool =
  let n = p.len
  for i in 0..<n:
    if ccw(p[(i + n - 1) mod n], p[i], p[(i + 1) mod n]) == -1: return false
  return true

import algorithm

# http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=CGL_4_A
proc convexHull(p:Polygon): Polygon =
  let n = p.len
  var
    k = 0
    p = p
  if n <= 2: return p
  p.sort(cmp[Point])
  var
    ch = newSeq[Point](2 * n)
    i = 0
  while i < n:
    while k >= 2 and cross(ch[k - 1] - ch[k - 2], p[i] - ch[k - 1]) < EPS: k.dec
    ch[k] = p[i]
    k.inc;i.inc
  i = n - 2
  var t = k + 1
  while i >= 0:
    while k >= t and cross(ch[k - 1] - ch[k - 2], p[i] - ch[k - 1]) < EPS: k.dec
    ch[k] = p[i]
    k.inc;i.dec
  ch.setLen(k - 1)
  return ch


let P = complex(nextFloat(), nextFloat())
let N = nextInt()
let p = newSeqWith(N, complex(nextFloat(), nextFloat()))

ans := float.inf

for i in 0..<N:
  let j = (i + 1) mod N
  # P, p[i], p[j]
  a := polar((p[i] - p[j]) / (P - p[j]))[1]
  b := polar((p[j] - p[i]) / (P - p[i]))[1]
  a = a.abs
  b = b.abs
  d := min(abs(p[i] - P), abs(p[j] - P))
  if a < PI*0.5 and b < PI*0.5:
    d.min= distance(initLine(p[i], p[j]), P)
  ans.min=d

echo ans
