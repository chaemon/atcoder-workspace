const
  DO_CHECK = false
  DEBUG = false
  DO_TEST = false

include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353


import lib/other/bitutils

proc calc_naive(i, j, s, r0, c0:int):int =
  if i == 0 or j == 0:
    if s == 0: return 1
    else: return 0
  proc calc(S:seq[string]):int =
    let
      N = S.len
      M = S[0].len
    if S[0][0] == '#' or S[N - 1][M - 1] == '#': return 0
    var dp = Seq[N, M:0]
    dp[0][0] = 1
    for i in N:
      for j in M:
        if i + 1 < N and S[i + 1][j] == '.':
          dp[i + 1][j] += dp[i][j]
        if j + 1 < M and S[i][j + 1] == '.':
          dp[i][j + 1] += dp[i][j]
    return dp[N - 1][M - 1]
  var ans = 0
  for b in 2^(i * j):
    var S = Seq[i + 1: '.'.repeat(j + 1)]
    for i2 in 1..i:
      for j2 in 1..j:
        let r = (j2 - 1) * i + (i2 - 1)
        if b[r] == 1:
          S[i2][j2] = '#'
    if S[i][j] == '#': continue
    var
      ok = true
      s1, r1, c1 = 0
    for i2 in 1..i:
      var ct = 0
      for j2 in 1..j:
        if S[i2][j2] == '#': ct.inc
      if ct > 1: ok = false
    for j2 in 1..j:
      var ct = 0
      for i2 in 1..i:
        if S[i2][j2] == '#': ct.inc
      if ct > 1: ok = false
    if not ok: continue
    for i2 in 1..<i:
      for j2 in 1..<j:
        if S[i2][j2] == '#': s1.inc
    for j2 in 1..<j:
      if S[i][j2] == '#': r1.inc
    for i2 in 1..<i:
      if S[i2][j] == '#': c1.inc
    if s1 == s and r1 == r0 and c1 == c0:
      ans += calc(S)
  return ans

var dp:array[205, array[205, array[205, array[2, array[2, mint]]]]]

solveProc solve(N:int, A:seq[int]):
  var
    #dp = Seq[N + 2, N + 2, N + 2, 2, 2: mint(0)] # i, j, c, r0, c0
    row = Seq[N + 2: -1]
    col = Seq[N + 2: -1]
    row_ct, col_ct = Seq[N + 2: 0] # 0 ..< iのうち決まっていないものの数
    rs = 0
    cs = 0
    N2 = 0
  for i in N: # (i + 1, A[i])
    if A[i] != -1:
      row[i + 1] = A[i]
      col[A[i]] = i + 1
    else:
      N2.inc
  for i in 1..N:
    row_ct[i] = rs
    col_ct[i] = cs
    if row[i] == -1: rs.inc
    if col[i] == -1: cs.inc
  row_ct[N + 1] = rs
  col_ct[N + 1] = cs
  dp[0][0][0][0][0] = 1
  for i in 0 .. N + 1:
    for j in 0 .. N + 1:
      for s in 0 .. N2:
        for r0 in 0..1:
          for c0 in 0..1:
            #debug i, j, s, r0, c0, dp[i][j][s][r0][c0]
            #if i in 1..N and j in 1..N:
            #  debug calc_naive(i, j, s, r0, c0)
            #  doAssert dp[i][j][s][r0][c0] == calc_naive(i, j, s, r0, c0)
            if dp[i][j][s][r0][c0] == 0: continue
            # (i, j)にいて、(1..<i, 1..<j)にはc個が決定されている
            # (i + 1, j)に行く
            if i + 1 <= N + 1 and row[i + 1] != j:
              if row[i + 1] == -1:
                # i + 1行にブロックを置かない
                dp[i + 1][j][s + r0][0][c0] += dp[i][j][s][r0][c0]
                # i + 1行にブロックを置く
                var d = col_ct[j] - s - r0 # ブロック置く場所の選択肢
                if d > 0:
                  dp[i + 1][j][s + r0][1][c0] += dp[i][j][s][r0][c0] * d
              else: # ブロックの位置が決まってる
                dp[i + 1][j][s + r0][0][c0] += dp[i][j][s][r0][c0]
            # (i, j + 1)に行く
            if j + 1 <= N + 1 and col[j + 1] != i:
              if col[j + 1] == -1:
                # j + 1列にブロックを置かない
                dp[i][j + 1][s + c0][r0][0] += dp[i][j][s][r0][c0]
                # j + 1列にブロックを置く
                var d = row_ct[i] - s - c0 # ブロック置く場所の選択肢
                if d > 0:
                  dp[i][j + 1][s + c0][r0][1] += dp[i][j][s][r0][c0] * d
              else:
                dp[i][j + 1][s + c0][r0][0] += dp[i][j][s][r0][c0]
            discard
  echo dp[N + 1][N + 1][N2][0][0]
  return

block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
