when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:int, a:seq[int], b:seq[int]):
  var
    dp = Seq[N + 1, S + 1: false]
    prev = Seq[N + 1, S + 1: -1] # 0: a, 1: b, -1: not use
  dp[0][0] = true
  for i in N:
    for s in 0 .. S:
      if not dp[i][s]: continue
      if s + a[i] <= S:
        if not dp[i + 1][s + a[i]]:
          dp[i + 1][s + a[i]] = true
          prev[i + 1][s + a[i]] = 0
      if s + b[i] <= S:
        if not dp[i + 1][s + b[i]]:
          dp[i + 1][s + b[i]] = true
          prev[i + 1][s + b[i]] = 1
  if not dp[N][S]:
    echo NO;return
  var
    i = N - 1
    s = S
    ans = ""
  while i >= 0:
    # i + 1 => i
    let u = prev[i + 1][s]
    if u == 0:
      ans.add 'H'
      s -= a[i]
    elif u == 1:
      ans.add 'T'
      s -= b[i]
    else:
      doAssert false
    i.dec
    discard
  ans.reverse
  echo YES
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, S, a, b)
else:
  discard

