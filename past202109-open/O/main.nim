when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

# Failed to predict input format
solveProc solve():
  # 試合を上から1; 2, 3; 4, 5, 6, 7とつけていく
  # 1〜2^N-1まである
  let
    N, M = nextInt()
    P = Seq[2^N: nextInt()]
  var
    W, L = newSeq[int](M)
  for i in M:
    W[i] = nextInt() - 1
    L[i] = nextInt() - 1
  var
    must_win, must_lose = Seq[2^(N + 1): -1]
    player = Seq[2^(N + 1): seq[int]]
    winner = Seq[2^(N + 1): seq[mint]] # player[i]を勝たせる場合の数
    pos = Seq[2^N: int]
  for i in P.len:
    let t = 2^N + i
    player[t].add P[i]
    winner[t].add 1
    pos[P[i]] = t
  for i in 1 ..< 2^N << 1:
    player[i] = player[i * 2] & player[i * 2 + 1]
    player[i].sort
    winner[i] = Seq[player[i].len: mint(0)]
  for i in M:
    var
      Wi = pos[W[i]]
      Li = pos[L[i]]
    while true:
      if must_win[Wi] != -1 and must_win[Wi] != W[i]:
        echo 0;return
      must_win[Wi] = W[i]
      if Wi == Li:
        if must_lose[Li] != -1 and must_lose[Li] != L[i]:
          echo 0;return
        must_lose[Li] = L[i]
        break
      if must_win[Li] != -1 and must_win[Li] != L[i]:
        echo 0;return
      must_win[Li] = L[i]
      Wi.div= 2
      Li.div= 2
  for i in 1 ..< 2^N << 1:
    # 試合iを考える
    # i * 2とi * 2 + 1の勝者が戦う
    var
      j = i * 2
      k = j + 1
    if must_win[i] != -1:
      var u = player[j].binarySearch(must_win[i])
      if u == -1:
        swap j, k
        u = player[j].binarySearch(must_win[i])
      # player[j][u]がmustwin[i]
      doAssert u != -1
      let wi = player[i].binarySearch(must_win[i])
      if must_lose[i] != -1:
        # player[k]側にmust_loseがいる
        var v = player[k].find(must_lose[i])
        winner[i][wi] = winner[j][u] * winner[k][v]
      else:
        winner[i][wi] = winner[j][u] * winner[k].sum
    else:
      doAssert must_lose[i] == -1
      let
        js = winner[j].sum
        ks = winner[k].sum
      for pi in player[i].len:
        let p = player[i][pi]
        var pj = player[j].binarySearch(p)
        if pj != -1:
          winner[i][pi] = winner[j][pj] * ks
        else:
          var pk = player[k].binarySearch(p)
          winner[i][pi] = js * winner[k][pk]
    discard
  echo winner[0].sum
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

