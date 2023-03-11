const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353


#[
a_k := 初期状態から初めてk回目で全部同色になる確率
b_k := 全部同色から初めてk回目で再び全部同色になる確率

f(x) = (x - 1)Σa_k x^k
g(x) = (x - 1)Σb_k x^k

求める解は(f(x) / g(x))'のx=1での値
つまりf(1), g(1), f'(1), g'(1)がわかればよい

]#

import rationals
import lib/other/bitutils

proc permutations(a:seq[int], k:int):seq[seq[int]] =
  let N = a.len
  var
    selected = Seq[N:false]
    b = newSeq[seq[int]]()
  proc f(d:int, v:seq[int]) =
    var v = v
    if d == k:
      b.add v
      return
    for i in N:
      if selected[i]: continue
      selected[i] = true
      v.add(a[i])
      f(d + 1, v)
      selected[i] = false
      discard v.pop()
  var v = newSeq[int]()
  f(0, v)
  return b

proc reduce(a:seq[(seq[int], Rational[int])]):auto =
  var x = initTable[seq[int], Rational[int]]()
  for (k, v) in a:
    if k notin x: x[k] = initRational(0, 1)
    x[k] += v
  result = newSeq[(seq[int], Rational[int])]()
  var keys:seq[seq[int]]
  for k in x.keys: keys.add k
  keys.sort
  for k in keys:
    result.add((k, x[k]))

proc test(a:seq[int], k:int) =
  let N = a.len
  var a = @[(a, initRational(1, 1))]
  for i in k:
    var a2:seq[(seq[int], Rational[int])]
    for (a, p) in a:
      for b in 2^N:
        var p = p / 2^N
        var X:seq[int]
        for i in N:
          if b[i] == 1: X.add i
        let K = X.len
        let u = permutations((0..<N).toSeq, K)
        for P in u:
          var a = a
          for i in K:
            a[X[i]] = P[i]
          a2.add (a, p / u.len)
    a2 = a2.reduce
    swap a, a2
  debug a

#block:
#  let M = 4
#  for i in 0..M:
#    debug i
#    test(@[0, 1], i)
#  
#  for i in 0..M:
#    debug i
#    test(@[0, 0], i)


solveProc solve(N:int, A:seq[int]):
  let p0 = mint(1) / mint(2)
  var prod = Seq[N: mint(0)] # prod[i]は1 / (1 - (1 / 2)^N) * (1 - (1 / 2)^(N - 1)) * ...とi + 1個かけたもの
  block:
    p := p0^N
    for i in 0 ..< N:
      if i == 0:
        prod[i] = mint(1) / mint(1 - p)
      else:
        prod[i] = prod[i - 1] / mint(1 - p)
      p *= 2
  proc calc_prod(p:Slice[int]):mint =
    result = mint(1)
    for i in p:
      result /= (1 - p0 ^ i)
  proc f():mint =
    # 色ごとに決めるが、固定が一個でもあると(1 - x)がかけられて0になる
    # つまり固定はないとしよい。つまりすべての色について全部塗り替える
    # 塗り替える順番はN!通り
    # 対象の並べ替え(N回)についてはk番目(0-based)はN - k個が自由に選べるが目的の箇所は必ず選ばないといけない。
    # つまり(2^(N - k - 1)通りの選択肢がある) (k = 0 ..< N)
    # 指数の和はN + (N - 1) + (N - 2) + ... + 0 = N * (N + 1) / 2
    # そのうち、1箇所は目的の色でないといけない(確率1/N)。それ以外はなんでもいい
    # f(1) = g(1)な気がする
    #result = calc_prod(1 .. N) * mint.fact(N) * p0 ^ ((N * (N + 1)) div 2) / mint(N)^N
    result = prod[^1] * mint.fact(N) * p0 ^ ((N * (N + 1)) div 2) / mint(N)^N
    result *= N
  proc g():mint =
    return f()
  proc calc_from(c:int):mint =
    result = 0
    # 初期状態でc個ある色をk回で全部同色にする。それに(1 - x)をかけて微分して1を代入した値を返す
    # 不動点がない場合: (1 - x)がかけられて消える。微分される
    # ここはcに依存しないので意味ない気がする
    #block:
    #  # 1 / (1 - 1 / 2 x)を微分すると、 1 / 2 * 1 / (1 - 1 / 2 x)^2なので、1 / 2 * (1 - 1 / 2)がよけいにかかる
    #  var
    #    q = p0
    #    s = mint(0)
    #  for i in 1 .. N:
    #    s += q / (1 - q)
    #    q *= p0
    #  #s *= prod[^1] * mint.fact(N) * p0 ^ ((N * (N + 1)) div 2) / mint(N)^N
    #  s *= calc_prod(1 .. N) * mint.fact(N) * p0 ^ ((N * (N + 1)) div 2) / mint(N)^N
    #  s *= N
    #  result += s
    # 不動点がある場合: (1 - x)があるので、微分がなくなって引いていけば良い
    for i in 0 ..< c:
      # 動かすものの個数をiとする
      # N - c + i個を適当な順番で処理
      # 2^(c - i + 1) * 2^(c - i + 2) * ... * 2^Nの和
      let s = ((c - i + N + 1) * (N - c + i)) div 2
      #result -= mint.C(c, i) * calc_prod(c - i .. N) * mint.fact(N - c + i) * p0^s / mint(N)^(N - c + i)
      result -= mint.C(c, i) * prod[N - c + i] * mint.fact(N - c + i) * p0^s / mint(N)^(N - c + i)
    return
  proc calc_d(ct:seq[int]):mint =
    result = 0
    for c in ct:
      result += calc_from(c)
    discard
  proc fd():mint =
    ct := Seq[N: 0]
    for i in N: ct[A[i]].inc
    doAssert ct.sum == N
    return calc_d(ct)
  proc gd():mint =
    ct := Seq[N: 0]
    ct[0] = N
    return calc_d(ct)
  echo (fd() - gd()) / g()
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt() - 1)
  solve(N, A)
else:
  discard

