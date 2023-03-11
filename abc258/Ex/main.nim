const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/ntt
import lib/math/formal_power_series
import lib/math/coef_of_generating_function
import lib/math/matrix

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc zero():mint = mint(0)
proc unit():mint = mint(1)
proc isZero0(a:mint):bool = a == 0

#type M = DynamicMatrixType(mint)
type M = StaticMatrixType(mint, zero, unit)

proc calc_coef(n:int):(mint, mint) =
  var
    A = M.init([
      [-1, 1], 
      [1 , 0]])
    b = M.init([0, 1])
  b = A ^ n * b
  return (b[0], b[1])

proc calc_fib(n:int):(mint, mint) = # (f(n), f(n - 1))
  var
    A = M.init([
      [1, 1], 
      [1, 0]])
    b = M.init([1, 1])
  b = A^(n - 1) * b
  return (b[0], b[1])

solveProc solve(N:int, S:int, A:seq[int]):
  var
    A = A & S
    x = initVar[mint]()
    a = mint(1)
    b = mint(0)
  for i in N + 1:
    # g(x): Σc_i * x^A[i]とする
    # c_iは合計がA[i]で累積和がA[i]以外にないもの
    # x / (1 - x - x^2) - g(x) * x / (1 - x - x^2)のx^A[i]の係数がc_iである
    # g(x)を更新
    # (1 - x * g(x)) mod (1 - x - x^2) = a x + bとする
    #let c = ((a * x + b) // (1 - x - x^2))[A[i]]
    let (fn, fn1) = calc_fib(A[i])
    let c = fn1 * a + fn * b
    if i == N: echo c;break
    # g(x)にc x^A[i]を減じる。つまりx^(A[i]+1) mod (1 - x - x^2)を調べる
    let (ad, bd) = calc_coef(A[i] + 1)
    a -= c * ad
    b -= c * bd
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, S, A)
else:
  discard

