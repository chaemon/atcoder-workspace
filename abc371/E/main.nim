when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A
  var ct = Seq[N: seq[int]]
  for i in N:
    ct[A[i]].add i
  var ans = 0
  for i, v in ct:
    if v.len == 0: continue
    #debug i, v
    for j in v.len:
      # v[j]を初めて通る区間を数える
      var s = if j > 0: v[j - 1] + 1 else: 0
      # l ..< r
      # l = s .. v[j]
      # r = v[j] + 1〜N
      let d = (v[j] - s + 1) * (N - v[j])
      #debug j, s, d
      ans += d
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

