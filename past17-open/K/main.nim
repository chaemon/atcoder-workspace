when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, S:string):
  var
    pos:seq[int]
    s = 0
  for i in N:
    if S[i] == '?':
      pos.add i
    else:
      s += (i + 1) * (S[i] - '0')
  var dp = Seq[pos.len + 1: Array[10: -1]]
  dp[0][0] = 0
  for i in pos.len:
    for x in 10:
      if dp[i][x] == -1: continue
      for y in 10:
        # S[pos[i]]をyにする
        let r = (x + y * (pos[i] + 1)) mod 10
        dp[i + 1][r] = y
  var r = (-s).floorMod 10
  if dp[^1][r] == -1:
    echo "No"; return
  echo "Yes"
  var
    ans = S
  for i in 0 ..< pos.len << 1:
    let d = dp[i + 1][r]
    r = (r - (pos[i] + 1) * d).floorMod 10
    ans[pos[i]] = '0' + d
  block:
    s := 0
    for i in ans.len:
      s += (ans[i] - '0') * (i + 1)
      s.mod=10
    if s != 0:
      while true:
        discard
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

