when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  ans := 0
  #for i in N:
  #  for j in i + 1 ..< N:
  #    if A[i] == A[j]: continue
  #    ans += min(i + 1, N - j)
  for i in N:
    if i >= N - i - 1: break
    # j = i + 1 ..< N - iはi + 1を足す
    ans += (i + 1) * (N - i * 2 - 1)
    # j = N - i ..< NはN - jを足す
    # 1 から iを足す
    ans += (i * (i + 1)) div 2
  # 同じのを引く
  block:
    var t = initTable[int, seq[int]]()
    var d = 0
    for i,a in A:
      t[a].add i
    for k, v in t:
      # 各vについて
      s := @[0]
      for i, a in v:
        # aの反対側の位置
        let t = N - 1 - a
        if a <= t: break
        var ui = v.lower_bound(t)
        # uiの位置までの和をとる
        d += s[ui]
        # ui ..< tまでの
        d += (t - ui) * (N - a)
        s.add s[^1] + a
      discard
    ans -= d
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

