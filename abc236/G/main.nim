const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/matrix

type D = distinct int

proc `*`(a, b:D):D = max(a.int, b.int).D
proc `+`(a, b:D):D = min(a.int, b.int).D
proc `$`(a:D):string = $(a.int)
proc `==`(a, b:D):bool = a.int == b.int

# zero: inf, one: -inf

proc zero():D = D(int.inf)
#proc zero(a:D):D = D(int.inf)
proc unit():D = D(-int.inf)
proc isZero(a:D):bool = a == zero()

solveProc solve(N:int, T:int, L:int, u:seq[int], v:seq[int]):
  type M = MatrixType(D, zero = zero, unit = unit)
  var A = M.init(Seq[N, N: zero()])
  for t in T:
    A[v[t]][u[t]] = D(t)
  var b = M.init(Seq[N: zero()])
  for i in N:
    b[i] = if i == 0: unit() else: zero()
  b = A^L * b
  ans := b.mapIt(if it.int == int.inf: -1 else: it.int + 1)
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var T = nextInt()
  var L = nextInt()
  var u = newSeqWith(T, 0)
  var v = newSeqWith(T, 0)
  for i in 0..<T:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, T, L, u, v)
else:
  discard

