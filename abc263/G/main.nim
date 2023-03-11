const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/maxflow

import lib/math/divisor

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var ones = 0
  var
    odd, even = Seq[tuple[A, B:int]]
  for i in N:
    if A[i] == 1:
      ones += B[i]
    elif A[i] mod 2 == 1:
      odd.add (A[i], B[i])
    else:
      even.add (A[i], B[i])
  var
    prime = Seq[odd.len, even.len: bool]
    prime_one = Seq[even.len: bool]
  for i in even.len:
    let S = even[i].A + 1
    if S.divisor.len == 2:
      prime_one[i] = true
    else:
      prime_one[i] = false
  for i in odd.len:
    for j in even.len:
      let S = odd[i].A + even[j].A
      if S.divisor.len == 2:
        prime[i][j] = true
      else:
        prime[i][j] = false
  proc f(m:int):int =
    # 1をm個使う
    var
      g = initMaxFlow[int](odd.len + even.len + 3)
      s = odd.len + even.len
      t = s + 1
      o = t + 1
    for i in odd.len:
      g.addEdge(s, i, odd[i].B)
    for i in odd.len:
      for j in even.len:
        if prime[i][j]:
          g.addEdge(i, odd.len + j, int.inf)
    for i in even.len:
      g.addEdge(i + odd.len, t, even[i].B)
      if prime_one[i]:
        g.addEdge(o, i + odd.len, int.inf)
    g.addEdge(s, o, ones - 2 * m)
    return g.flow(s, t) + m
  var
    l = 0
    r = ones div 2
  while r - l >= 3:
    let
      t = (r - l) div 3
      L0 = f(l + t)
      R0 = f(r - t)
    if L0 > R0:
      r -= t
    else:
      l += t
  var ans = -int.inf
  for u in l .. r:
    ans.max=f(u)
  echo ans
  Naive:
    var v = Seq[int]
    for i in N:
      for j in B[i]:
        v.add A[i]
    var
      ans = 0
      selected = Seq[v.len: false]
      t = 0
    proc f(i: int) =
      if i == v.len:
        ans.max=t;return
      elif selected[i]:
        f(i + 1)
      else:
        # iを選ぶ
        for j in i + 1 ..< v.len:
          if selected[j]: continue
          if (v[i] + v[j]).divisor.len == 2:
            t.inc
            selected[i] = true
            selected[j] = true
            f(i + 1)
            selected[i] = false
            selected[j] = false
            t.dec
        # iを選ばない
        f(i + 1)
    f(0)
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  var N = 4
  for i1 in 1..4:
    for i2 in 1..4:
      for i3 in 1..4:
        for i4 in 1..4:
          var
            A = @[1, 2, 3, 4]
            B = @[i1, i2, i3, i4]
          test(4, A, B)
  discard

