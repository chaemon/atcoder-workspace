include atcoder/extra/header/chaemon_header


#const DEBUG = true

proc solve(N:int, S, X:string) =
  dp := Seq(N + 1, 7, int)
  vis := Seq(N + 1, 7, false)
  proc calc(i, r:int):int = # t = 0: aoki, t = 1: takahashi
    if vis[i][r]: return dp[i][r]
    vis[i][r] = true
    if i == N:
      if r == 0: result = 1
      else: result = 0
    else:
      let t = if X[i] == 'A': 0 else: 1
      result = 1 - t
      block:
        var r2 = r * 10
        r2 .mod= 7
        if calc(i + 1, r2) == t: result = t
      block:
        let c = S[i].ord - '0'.ord
        debug i, c
        var r2 = r * 10 + c
        r2 .mod= 7
        if calc(i + 1, r2) == t: result = t
    dp[i][r] = result
    debug i, r, result
  if calc(0, 0) == 0:
    echo "Aoki"
  else:
    echo "Takahashi"
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  var X = nextString()
  solve(N, S, X)
#}}}

