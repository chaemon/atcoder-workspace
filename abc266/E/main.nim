const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  var
    memo = Seq[N + 1: float]
    vis = Seq[N + 1: false]
  proc f(n:int):float =
    if n == 1: return 3.5
    if vis[n]: return memo[n]
    vis[n] = true
    result = 0.0
    for t in 1 .. 6:
      let u = f(n - 1)
      result += max(t, u) / 6
    memo[n] = result
  echo f(N)

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard
