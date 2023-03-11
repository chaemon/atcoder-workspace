include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc solve_naive(N, M, Q:int):int =
  var q:seq[seq[int]]
  var qs:seq[seq[seq[int]]]
  proc generate(i:int) = 
    if i == Q:
      qs.add(q);return
    # type t = 1
    for l in 0..<N:
      for r in l..<N:
        for v in 0..<M:
          q.add(@[1,l,r,v])
          generate(i + 1)
          discard q.pop()
    # type t = 2
    for l in 0..<N:
      for r in l..<N:
        for v in 0..<M:
          q.add(@[2,l,r,v])
          generate(i + 1)
          discard q.pop()
    for l in 0..<N:
      for r in l..<N:
        q.add(@[3,l,r])
        generate(i + 1)
        discard q.pop()
  generate(0)
  proc run(q:seq[seq[int]]):int =
    result = 0
    var a = Seq(N, 0)
    for q in q:
      if q[0] == 1:
        let (l,r,v) = (q[1], q[2], q[3])
        for i in l..r: a[i].min= v
      elif q[0] == 2:
        let (l,r,v) = (q[1], q[2], q[3])
        for i in l..r: a[i].max= v
      else:
        let (l,r) = (q[1], q[2])
        result += a[l..r].sum
  var ans = 0
  for q in qs:
    let d = q.run
#    if d > 0:
#      debug q, d
    ans += d
  echo ans
  return ans

proc solve_naive2(N:int, M:int, Q:int):int =
  let N2 = mint(N * (N + 1) div 2)
  ans := Seq(M, mint(0))
  for j in 0..<N:
    let alpha = mint((j + 1) * (N - j))
    f := Seq(M, mint(0))
    f[0] = 1
    for q in 0..<Q:
      let p = (N2 * (M + M + 1))^(Q - q - 1)
#      debug j, q, f, p
      for k in 0..<M:
        ans[k] += k * alpha * f[k] * p
      s := f.sum
      f2 := Seq(M, mint(0))
      for k in 0..<M:
        f2[k] = s * alpha + f[k] * (N2 * (M * 2 + 1) - alpha * M)
      swap(f, f2)
  echo ans.sum
  return ans.sum.val

proc geometricProgressionSum[T](r:T, n:int):T =
  if r == 1:
    return r * n
  else:
    return (r^n - 1) / (r - 1)
proc geometricProgressionSum[T](r:T, p:Slice[int]):T =
  if r == 1:
    return r * (p.b - p.a + 1)
  else:
    return geometricProgressionSum(r, p.b + 1) - geometricProgressionSum(r, p.a)

proc solve(N:int, M:int, Q:int):int {.discardable.} =
#  solve_naive(N, M, Q)
#  solve_naive2(N, M, Q)
  let N2 = mint(N * (N + 1) div 2)
  var ans = mint(0)
  for j in 0..<N:
    let
      alpha = mint((j + 1) * (N - j))
      t = N2 * (M * 2 + 1) - alpha * M
      t2 = N2 * (M * 2 + 1)
      r = (alpha * M + t) / t
    assert r != 1
    let
      r2 = t * r / t2
      r3 = t / t2
    var s = geometricProgressionSum(r2, Q) - geometricProgressionSum(r3, Q)
    s *= t2^(Q - 1) * alpha * (M * (M - 1) div 2) * alpha / (t * (r - 1))
    ans += s
  echo ans
  return ans.val

proc test() =
  for N in 1..3:
    for M in 1..3:
      for Q in 1..3:
        debug N, M, Q
        let ans_naive = solve_naive(N, M, Q)
        let ans_naive2 = solve_naive2(N, M, Q)
        let ans =solve(N, M, Q)
        assert ans == ans_naive and ans == ans_naive2

# input part {{{
block:
  when declared DEBUG:
    test()
  else:
    var N = nextInt()
    var M = nextInt()
    var Q = nextInt()
    solve(N, M, Q)
#}}}
