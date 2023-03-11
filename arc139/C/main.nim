const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int):
  proc check(ans:seq[(int, int)]) =
    let L = max(N * 3 + M + 1, M * 3 + N + 1)
    var X, Y = Seq[L: false]
    for a in ans:
      let
        x = a[0] * 3 + a[1]
        y = a[1] * 3 + a[0]
      doAssert not X[x]
      X[x] = true
      doAssert not Y[y]
      Y[y] = true
  proc calc(N, M:int):seq[(int, int)] = # 0-base
    if N > M:
      result = calc(M, N)
      for i in result.len:
        swap result[i][0], result[i][1]
    else: # N <= M
      for i in 0..N-1:result.add (i, i)
      for i in 0..N-2:result.add (i, i + 1);result.add (i + 1, i)
      # mod 4で余り2を埋める
      if M == N or M == N + 1:
        var i = 0
        while i + 2 < N and i + 2 < M:
          result.add (i, i + 2)
          result.add (i + 2, i)
          i += 2
        if i < N and i + 2 < M:
          result.add (i, i + 2)
        if M == N + 1:
          result.add (N - 1, N)
        discard
      else:
        for i in 0..N-1:
          result.add (i, i + 2)
        for i in N..<M:
          if i == N + 1: continue
          result.add (N - 1, i)
      if M >= N + 2:
        doAssert result.len == (N - 1) * 3 + M - 1 + 1
  var ans = calc(N, M)
  check(ans)
  echo ans.len
  for a in ans:
    echo a[0] + 1, " ", a[1] + 1
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  for N in 1..30:
    for M in 1..30:
      solve(N, M)
  discard

