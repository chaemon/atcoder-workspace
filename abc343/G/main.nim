when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/string as atcoder_string
import lib/other/bitutils

solveProc solve(N:int, S:seq[string]):
  var
    N = N
    S = S
  block:
    var st = initSet[string]()
    for s in S:
      st.incl s
    S = st.toSeq()
    N = S.len
  var
    lcp = Seq[N, N: 0]
    contained = initSet[int]()
  for i in N:
    for j in N:
      if i == j: continue
      # S[i]の後ろにS[j]をつなげるときに何文字被ることができるか？
      let
        T = S[j] & '?' & S[i]
        za = z_algorithm(T)
        b = S[j].len + 1
      # za[b + k]はS[j]とS[i][k .. ^1]のLCPの長さになる
      for k in S[i].len:
        if za[b + k] >= S[j].len:
          contained.incl j
          break
        elif k + za[b + k] >= S[i].len:
          lcp[i][j].max=S[i].len - k;break
  var v:seq[int] # 含まれないもの
  for i in N:
    if i notin contained:
      v.add i
  var dp = Seq[2^v.len, v.len: int.inf]
  for i in v.len:
    dp[1 shl i][i].min=S[v[i]].len
  for b in 2^v.len:
    for i in v.len:
      for j in v.len:
        dp[b xor [j]][j].min=dp[b][i] - lcp[v[i]][v[j]] + S[v[j]].len
  ans := int.inf
  for i in v.len:
    ans.min=dp[2^v.len - 1][i]
  echo ans

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

