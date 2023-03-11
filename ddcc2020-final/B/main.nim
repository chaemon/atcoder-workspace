const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/matrix, lib/other/operator

type C = object
  a, b:int

proc eval(l:C, x:int):int =
  if x <= l.b: return l.a
  else: return l.a - l.b + x

proc zero():C = C(a: -int.inf, b:int.inf)
proc unit():C = C(a:0, b:0)

const Op = getOperator(C):
  proc zero():C = C(a: -int.inf, b:int.inf)
  proc unit():C = C(a:0, b:0)

  proc `*`(l, r:C):C = # l * r
    if l == zero() or r == zero(): return zero()
    a := eval(l, r.a)
    s := l.a + r.a - l.b - r.b
    b := a - s
    return C(a:a, b:b)
  
  proc `+`(l, r:C):C =
    if l == zero(): return r
    elif r == zero(): return l
    a := max(l.a, r.a)
    sl := l.a - l.b
    sr := r.a - r.b
    s := max(sl, sr)
    b := a - s
    return C(a:a, b:b)

converter toC(n:int):C =
  if n == 0: return zero()
  elif n == 1: return unit()
  else: doAssert false

#type MT = DynamicMatrixType(C, Op)
type MT = StaticMatrixType(C, Op)

solveProc solve(N:int, M:int, W:int, S:int, K:int, u:seq[int], v:seq[int], w:seq[int]):
  A := MT.init(200, 200)
  #A := MT.init(N, N)
  for i in M:
    if w[i] >= 0:
      A[v[i], u[i]] = C(a:w[i], b:0)
    else:
      A[v[i], u[i]] = C(a:0, b: -w[i])
  #b := MT.initVector(N)
  b := MT.initVector(200)
  b[S] = unit()
  b = A^K * b
  ans := -int.inf
  for u in N:
    ans.max=eval(b[u], W)
  if ans != -int.inf:
    echo ans
  else:
    echo -1
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var W = nextInt()
  var S = nextInt() - 1
  var K = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var w = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    w[i] = nextInt()
  solve(N, M, W, S, K, u, v, w)
else:
  discard

