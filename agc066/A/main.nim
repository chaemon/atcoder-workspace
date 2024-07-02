when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, d:int, A:seq[seq[int]]):
  proc get_diff(r, s:int):int =
    # r + x ≡s (mod 2 * d)
    # となるxの最小値を求める
    var t = s - r
    if abs(t) <= d: return t
    elif 0 < t:
      return t - 2 * d
    elif t < 0:
      return t + 2 * d
    else:
      doAssert false
  var
    ans = A
    v = Seq[N, N: int]
    ct, x = Seq[2 * d: 0]
  for i in N:
    for j in N:
      var a = A[i][j]
      if (i + j) mod 2 == 1:
        a += d
      a = a.floorMod(2 * d)
      v[i][j] = a
      ct[a].inc
  for r in 2 * d:
    for s in 2 * d:
      var c = abs(get_diff(r, s))
      x[s] += ct[r] * c
  var
    min_val = int.inf
    min_r = -1
  for r in 2 * d:
    if x[r] < min_val:
      min_val = x[r]
      min_r = r
  # min_rにする
  for i in N:
    for j in N:
      ans[i][j] += get_diff(v[i][j], min_r)
  for i in N:
    echo ans[i].join(" ")
  block test:
    var c = 0
    for i in N:
      for j in N:
        c += abs(ans[i][j] - A[i][j])
    doAssert c * 2 <= d * N^2
    for i in N:
      for j in N:
        if j + 1 < N:
          doAssert abs(ans[i][j] - ans[i][j + 1]) >= d
        if i + 1 < N:
          doAssert abs(ans[i][j] - ans[i + 1][j]) >= d
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var d = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, d, A)
else:
  discard

