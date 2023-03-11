
include lib/header/chaemon_header
import atcoder/modint

type mint = modint

import lib/math/arbitrary_mod_combination

solveProc solve(N:int, M:int):
  mint.setMod(M)

  #var f = mint(1)
  # vを固定してA_* = vとするvを考える
  # vを通るものがv以外に他にk個あるとすると
  # そのk個の選び方はC(N - 1, k)
  # それらのuについてのA_uの決め方k!通り
  # つまり(N - 1)! / (N - 1 - k)! = P(N - 1, k)
  # 残りの(N - k - 1)個についてはそれらのどれかになってればいいつまり(N - k - 1)^(N - k - 1)
  # vについてもその(N - k - 1)個のどれかならいい
  var Bin = initArbitraryModBinomial(M, N)
  ans := mint(0)
  for k in 0 .. N - 1:
    let d = mint(N - k - 1)^(N - k)
    let e = mint(k + 1)^(k - 1)
    #ans += d * e * combination(N - 1, k, M) * (k + 1)
    ans += d * e * Bin.C(N - 1, k) * (k + 1)
    #f *= N - 1 - k
  echo ans * N
  Naive:
    var ctc = Seq[N: 0]
    proc calc(A:seq[int]):int =
      var B = @[(0 ..< N).toSeq]
      for _ in N * 3:
        var
          b = B[^1]
          b2 = Seq[N: int]
        for i in N:
          b2[i] = A[b[i]]
        B.add b2
      result = 0
      var ct0 = Seq[N: 0]
      for j in B[0].len:
        var ct = Seq[N: 0]
        for i in B.len:
          ct[B[i][j]].inc
        for i in N:
          if ct[i] == 1:
            ct0[i].inc
        result += ct.count(1)
      for i in N:
        ctc[ct0[i]].inc
      #debug A, ct0
    var
      A = Seq[N: 0]
      ans = 0
    while true:
      let c = calc(A)
      ans += c
      ok := false
      for i in N:
        if A[i] < N - 1:
          A[i].inc
          ok = true
          break
        else:
          A[i] = 0
      if not ok: break
    for i in N:
      ctc[i].div=N
    debug ctc
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  test(4, 1000000)
