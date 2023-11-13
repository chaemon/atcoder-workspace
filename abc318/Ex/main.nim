when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/convolution
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int):
  # a[n]: n個のサイクルの集合で重みもつける
  # b[n]: a[n]のうちAliceが正解になるもの
  # c[n]: Alice, Bobの両方が正解になるもの(すべての輪っかの長さが1)
  #
  # 長さk + 1の輪っか
  # a[0] = 1
  # a[n] = Σ(k = 0 〜 n - 1) C(n - 1, k) * C(n, k + 1) * k! * (k + 1)! * a[n - k - 1]
  # a[n] / ((n - 1)! * n!) = Σ(k = 0 〜 n - 1)  a[n - k - 1] / (n - k - 1)! * (n - k - 1)!
  var
    s = mint(0)
    a = newSeq[mint](N + 1)
  a[0] = 1
  s += a[0]
  for n in 1 .. N:
    a[n] = s * mint.fact(n - 1) * mint.fact(n)
    s += a[n] * mint.invFact(n) * mint.invFact(n)
  doAssert a[N] == mint.fact(N)^2

  # b[0] = 1
  # b[n] = Σ(k = 0 〜 n - 1) C(n - 1, k) * C(n, k + 1) * k! * k! * b[n - k - 1]
  # b[n] / ((n - 1)! * n!) = Σ(k = 0 〜 n - 1) 1 / (k + 1) * b[n - k - 1] / (n - k - 1)! * (n - k - 1)!
  var b = Seq[N + 1: mint(0)]
  proc calc(l, r:int) = # l ..< rのb[n]を決定
    if r - l == 1:
      if l == 0:
        b[l] = 1
      return
    let m = (l + r) div 2
    calc(l, m)
    # l ..< mのm ..< rへの寄与を更新
    # たたみこむべきはk = 0〜r - 1 - lへの1 / (k + 1)
    var c:seq[mint]
    for k in r - 1 - l:
      c.add mint.inv(k + 1)
    c = c.convolution(b[l ..< m])
    for i in c.len:
      let n = i + l + 1
      if n in m ..< r:
        b[n] += c[i] * mint.inv(n)
    calc(m, r)
  calc(0, N + 1)
  for i in b.len:
    b[i] *= mint.fact(i)^2

  var c = Seq[N + 1: mint(0)]
  for n in 0 .. N:
    c[n] = mint.fact(n)

  echo a[N] - b[N] * 2 + c[N]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

