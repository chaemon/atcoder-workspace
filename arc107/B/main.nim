include atcoder/extra/header/chaemon_header


proc solve(N:int, K:int) =
  var K = K.abs
  var S = Seq(N * 2 + 1, int)
  for s in 2..N:
    S[s] = s - 1
  for s in N + 1..N * 2:
    S[s] = 2 * N + 1 - s
  var
    ans = 0
    i = 2
  while true:
    if i + K >= S.len: break
    ans += S[i] * S[i + K]
    i.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}
