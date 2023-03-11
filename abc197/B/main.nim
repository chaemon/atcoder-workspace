include atcoder/extra/header/chaemon_header


const DEBUG = true

var d = [[0, 1], [1, 0], [0, -1], [-1, 0]]

# Failed to predict input format
block main:
  let H, W = nextInt()
  let X, Y = nextInt() - 1
  let S = Seq[H : nextString()]
  ans := 1
  for d in d:
    var (X, Y) = (X, Y)
    X += d[0]
    Y += d[1]
    while X in 0..<H and Y in 0..<W:
      if S[X][Y] == '#': break
      ans.inc
      X += d[0]
      Y += d[1]
  echo ans
  discard

