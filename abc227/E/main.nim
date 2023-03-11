const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

proc id(c:char):int =
  if c == 'K':
    return 0
  elif c == 'E':
    return 1
  elif c == 'Y':
    return 2
  else:
    assert false

const B = 1000
var dp = Array[32,32,32,B:0]

proc ReLU(a:int):int =
  if a < 0: return 0
  else: return a

solveProc solve(S:string, K:int):
  dp[0][0][0][0] = 1
  var pos = Seq[3:seq[int]]
  var ct = Seq[seq[int]]
  var v = Seq[3:0]
  for i in 0..<S.len:
    let cid = id(S[i])
    v[cid].inc
    pos[cid] &= i
    ct.add v
  for i in 0..pos[0].len:
    for j in 0..pos[1].len:
      for k in 0..pos[2].len:
        for c in 0..<B:
          if dp[i][j][k][c] == 0: continue
          if i < pos[0].len:
            let t = pos[0][i]
            let c2 = c + ReLU(ct[t][1] - j) + ReLU(ct[t][2] - k)
            if c2 < B:
              dp[i + 1][j][k][c2] += dp[i][j][k][c]
          if j < pos[1].len:
            let t = pos[1][j]
            let c2 = c + ReLU(ct[t][2] - k) + ReLU(ct[t][0] - i)
            if c2 < B:
              dp[i][j + 1][k][c2] += dp[i][j][k][c]
          if k < pos[2].len:
            let t = pos[2][k]
            let c2 = c + ReLU(ct[t][0] - i) + ReLU(ct[t][1] - j)
            if c2 < B:
              dp[i][j][k + 1][c2] += dp[i][j][k][c]
  var ans = 0
  for c in 0..min(B - 1, K):
    ans += dp[pos[0].len][pos[1].len][pos[2].len][c]
  echo ans
  return

when not DO_TEST:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  discard

