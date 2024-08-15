when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  var a:seq[int]
  for i in N:
    case S[i]:
      of 'R': a.add 0
      of 'S': a.add 1
      of 'P': a.add 2
      else: doAssert false
  var dp = Array[3: 0]
  for i in N:
    var dp2 = Array[3: 0]
    for j in 3: # 高橋くんは今回jを出す
      for k in 3: # 前回kを出した
        if j == k or (a[i] + 1) mod 3 == j: continue
        let u = if (j + 1) mod 3 == a[i]: 1 else: 0
        dp2[j].max=dp[k] + u
    dp = dp2.move
  echo dp.max
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

