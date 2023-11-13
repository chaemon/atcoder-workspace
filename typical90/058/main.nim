const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

const B = 10^5

solveProc solve(N:int, K:int):
  proc f(n:int):int =
    result = 0
    var n = n
    while n > 0:
      result += n mod 10
      n.div=10
  var
    a = Seq[B: -1]
    i = 0
    N = N
    K = K
  while true:
    if a[N] != -1:
      let d = i - a[N]
      var q = (K - i) div d
      K -= d * q
    if i == K:
      break
    if a[N] == -1:
      a[N] = i
    N += f(N)
    N.mod= B
    i.inc
  echo N
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
