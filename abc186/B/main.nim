include atcoder/extra/header/chaemon_header


proc solve(H:int, W:int, A:seq[seq[int]]) =
  var m = int.inf
  for i in 0..<H:
    for j in 0..<W:
      m.min=A[i][j]
  var ans = 0
  for i in 0..<H:
    for j in 0..<W:
      ans += A[i][j] - m
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
#}}}
