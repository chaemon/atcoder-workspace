include atcoder/extra/header/chaemon_header

const YES = "Possible"
const NO = "Impossible"

proc solve(A:int, B:int, d:seq[seq[int]]) =
  const M = 100
  var f = Seq(M + 1, M + 1, 0)
  for a in 0..M:
    for b in 0..M:
      for x in 1..A:
        for y in 1..B:
          f[a][b].max=d[x - 1][y - 1] - a * x - b * y
  for x in 1..A:
    for y in 1..B:
      var d0 = int.inf
      for a in 0..M:
        for b in 0..M:
          d0.min=a * x + b * y + f[a][b]
      if d0 != d[x - 1][y - 1]:
        echo NO
        return
  echo YES
  var g = newSeq[tuple[u, v, d:int]]()
  let
    S = 0
    T = M + 1
  for i in 0..<M:
    g.add (i, i + 1, -1) # X
    g.add (i + M + 2, i + M + 1, -2) # Y
  for u in 0..M:
    for v in 0..M:
      g.add (u, v + M + 1, f[u][v])
  echo (M + 1) * 2, " ", g.len
  for e in g:
    stdout.write e.u + 1, " ", e.v + 1, " "
    if e.d == -1:
      echo "X"
    elif e.d == -2:
      echo "Y"
    else:
      echo e.d
  echo S + 1, " ", T + 1
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var d = newSeqWith(A, newSeqWith(B, nextInt()))
  solve(A, B, d)
#}}}
