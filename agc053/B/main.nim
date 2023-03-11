include atcoder/extra/header/chaemon_header

import atcoder/lazysegtree

const DEBUG = true
const DO_TEST = false

import atcoder/extra/other/bitutils

solveProc solve(N:int, V:seq[int]):
  var p = Seq[(int, int)]
  for i in N * 2:
    p.add((V[i], i))
  p.sort
  p.reverse
  var st = initLazySegTree(N, (a, b:int)=>min(a, b), ()=>int.inf, (a, b:int)=>a+b, (a, b:int)=>a+b, ()=>0)
  for i in 0..<N:
    st[i] = i + 1
  var ans = 0
  var added = 0
  for (V, i) in p:
    let d = if i < N: N - 1 - i else: i - N
    st.apply(d..^1, -1)
    if st.all_prod() < 0:
      st.apply(d..^1, 1)
      continue
    ans += V
    added.inc
    if added == N: break
  echo ans
  doAssert added == N
  Naive:
    var B = 2^(N * 2)
    var dp = Seq[B: -1]
    proc calc(b:int):int =
      if dp[b] >= 0: return dp[b]
      if b == 0: return 0
      let n = b.popCount
      if n mod 2 == 0:
        var ans = -int.inf
        for i in 0..<N*2:
          if b[i]: ans.max=calc(b xor [i]) + V[i]
        dp[b] = ans
      else:
        var v = Seq[int]
        for i in 0..<N*2:
          if b[i]: v.add(i)
        doAssert v.len == n
        let i = v[n div 2]
        dp[b] = calc(b xor [i])
      return dp[b]
    echo calc(B - 1)

import random

when not DO_TEST:
  var N = nextInt()
  var V = newSeqWith(2*N, nextInt())
  solve(N, V, output_stdout = true)
else:
#  var N = 3
#  var V = @[0, 2, 1, 0, 1, 0]
#  echo solve(N, V)
#  echo solve_naive(N, V)
  let N = 10
  while true:
    var V = Seq[N * 2: 0]
    for i in 0..<N * 2:
      V[i] = rand(0..100)
    echo N, V
    echo solve(N, V)
    echo solve_naive(N, V)
    doAssert test(N, V)
