when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, a:seq[seq[int]]):
  dp0 := Seq[N + 1, N + 1: seq[int32]]
  dp0[0][0] = @[a[0][0].int32]
  for i in N:
    for j in N:
      if i + j > N - 1: continue
      if i + 1 < N:
        for t in dp0[i][j]:
          dp0[i + 1][j].add t xor a[i + 1][j].int32
      if j + 1 < N:
        for t in dp0[i][j]:
          dp0[i][j + 1].add t xor a[i][j + 1].int32
  dp1 := Seq[N + 1, N + 1: seq[int32]]
  dp1[N - 1][N - 1] = @[a[N - 1][N - 1].int32]
  for i in 0 ..< N << 1:
    for j in 0 ..< N << 1:
      if i + j < N - 1: continue
      if i - 1 >= 0:
        for t in dp1[i][j]:
          dp1[i - 1][j].add t xor a[i - 1][j].int32
      if j - 1 >= 0:
        for t in dp1[i][j]:
          dp1[i][j - 1].add t xor a[i][j - 1].int32
  ans := 0
  for i in N:
    for j in N:
      if i + j == N - 1:
        var t = initTable[int32, int]()
        for s in dp1[i][j]:
          t[s].inc
        for u in dp0[i][j]:
          let p = u xor a[i][j].int32
          if p in t:
            ans += t[p]
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, a)
else:
  discard

