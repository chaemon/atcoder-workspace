when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(H:int, W:int, A:seq[seq[int]]):
  var S = Seq[H: ' '.repeat(W)]
  for i in H:
    for j in W:
      if A[i][j] == 0:
        S[i][j] = '0'
      else:
        S[i][j] = '1'
  proc is_ok(a, b, c:string):bool =
    for i in b.len:
      found := false
      for i2 in [i - 1, i + 1]:
        if i2 in 0 ..< b.len:
          if b[i2] == b[i]: found = true
      if a[i] == b[i] or c[i] == b[i]: found = true
      if not found: return false
    return true
  proc flip(a:string, i:int):string =
    if i == 0: return a
    doAssert i == 1
    result = a
    for j in a.len:
      result[j] = if result[j] == '0': '1' else: '0'
  var o = '2'.repeat(W)
  var dp = Seq[2, 2: int.inf]
  for i in 0 .. 1:
    for j in 0 .. 1:
      if is_ok(o, flip(S[0], i), flip(S[1], j)):
        dp[i][j] = i + j
  for t in 1 .. H - 2:
    var dp2 = Seq[2, 2: int.inf]
    for i in 0 .. 1:
      for j in 0 .. 1:
        if dp[i][j] == int.inf: continue
        for k in 0 .. 1:
          if is_ok(flip(S[t - 1], i), flip(S[t], j), flip(S[t + 1], k)):
            dp2[j][k].min= dp[i][j] + k
    dp = dp2.move
  ans := int.inf
  for i in 0 .. 1:
    for j in 0 .. 1:
      if dp[i][j] == int.inf: continue
      if is_ok(flip(S[H - 2], i), flip(S[H - 1], j), o):
        ans.min= dp[i][j]
  echo if ans == int.inf: -1 else: ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
else:
  discard

