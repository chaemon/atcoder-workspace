const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/divisor
import lib/math/matrix
import atcoder/extra/math/ntt
# TODO: includeだと大丈夫だけどimportだとだめ
include lib/math/kitamasa

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(K:int, N:int, M:int):
  if K == 1:
    echo 1;return
  var
    f = prime_factorization(M)
    #d = f.divisor # Mの約数
    #ct = Seq[d.len: 0] # M以下のdの倍数で真の倍数となるものの数
  # M = Πp_i^e_i
  proc calc(p, e:int):mint =
    # 1, p, p^2, ..., p^e
    let M = p^e
    var
      ct = Seq[e + 1: 0]
      d = (0 .. e).mapIt(p^it)
    for i, d in d:
      var t = M div d
      for (p, e) in f: # オイラー関数を使って求める
        if t mod p == 0:
          t .div= p
          t *= p - 1
      ct[i] = t
    type MT = DynamicMatrixType(mint)
    var A = MT.init(d.len)
    for i, x in d:
      # Mの約数について
      let M2 = M div x
      for j, y in d:
        # 別のMの約数をとる
        let g = gcd(M2, y)
        let k = d.binarySearch(g * x)
        doAssert k != -1
        A[k, i] += ct[j]
    var b = MT.initVector(d.len)
    block:
      let k = d.binarySearch(1)
      doAssert k != -1
      b[k] = 1
    b = kitamasa(A, b, K)
    #b = A^K * b
    block:
      let
        g = gcd(M, N)
        k = d.binarySearch(g)
      doAssert k != -1
      return b[k] / ct[k]

  ans := mint(1)
  for (p, e) in f:
    ans *= calc(p, e)
  echo ans
  discard

when not DO_TEST:
  var K = nextInt()
  var N = nextInt()
  var M = nextInt()
  solve(K, N, M)
else:
  discard

