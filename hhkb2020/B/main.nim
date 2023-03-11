include atcoder/extra/header/chaemon_header

proc solve(H:int, W:int, S:seq[string]) =
  var ans = 0
  for i in 0..<H:
    for j in 0..<W:
      if S[i][j] == '#': continue
      if i + 1 in 0..<H and S[i + 1][j] == '.': ans.inc
      if j + 1 in 0..<W and S[i][j + 1] == '.': ans.inc
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
#}}}
