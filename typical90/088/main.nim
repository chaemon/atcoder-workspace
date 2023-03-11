const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/other/bitset

solveProc solve(N:int, Q:int, A:seq[int], X:seq[int], Y:seq[int]):
  Pred X, Y
  var
    ban_list = Seq[N: initBitSet[88]()]
    ban = initBitSet[88]()
    c = initBitSet[88]()
    f:array[8889, seq[BitSet[88]]]
    found = -1
  for i in Q:
    ban_list[X[i]][Y[i]] = 1
  proc calc(i, s:int) =
    if i == N:
      f[s].add c
      if f[s].len == 2:
        var B, C = newSeq[int]()
        for i in N:
          if f[s][0][i] == 1: B.add i + 1
        for i in N:
          if f[s][1][i] == 1: C.add i + 1
        echo B.len
        echo B.join(" ")
        echo C.len
        echo C.join(" ")
        quit(0)
      return
    if ban[i] == 0:
      old_ban := ban
      ban = ban or ban_list[i]
      c[i] = 1
      calc(i + 1, s + A[i])
      c[i] = 0
      ban = old_ban
    calc(i + 1, s)
  calc(0, 0)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, Q, A, X, Y)
#}}}

