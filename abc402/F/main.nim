when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[seq[int]]):
  proc calc(A:seq[seq[int]], dig:seq[int]):seq[seq[int]] =
    var ans = Seq[N: seq[int]]
    proc f(i, j, s: int) =
      if i + j == N - 1:
        ans[i].add s;return
      var s = (s + A[i][j] * dig[i + j]).mod M
      if i + 1 < N: f(i + 1, j, s)
      if j + 1 < N: f(i, j + 1, s)
    f(0, 0, 0)
    for i in ans.len:
      ans[i].sort
      ans[i] = ans[i].deduplicate(isSorted = true)
    return ans
  var A2 = Seq[N, N: int]
  for i in N:
    for j in N:
      let
        i2 = N - 1 - j
        j2 = N - 1 - i
      A2[i][j] = A[i2][j2]
  var
    dig:seq[int]
  block:
    var p = 1
    for i in N * 2 - 1:
      dig.add p
      p *= 10
      p.mod=M
  var
    u = A.calc(dig[N .. 2 * N - 2].reversed)
    v = A2.calc(dig[0 .. N - 2])
    ans = -int.inf
  for i in N:
    for a in u[i]:
      let a = (a + A[i][N - 1 - i] * dig[N - 1]) mod M
      let
        s = a mod M
        d = M - 1 - s
        # d以下の最大
        j = v[i].upperBound(d) - 1
      if j >= 0:
        ans.max=a + v[i][j]
      ans.max=a + v[i][^1] - M
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, M, A)
else:
  discard

