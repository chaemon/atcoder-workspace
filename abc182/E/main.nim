include atcoder/extra/header/chaemon_header

import atcoder/dsu

proc solve() =
  let H, W, N, M = nextInt()
  var bl = newSeqWith(H, newSeqWith(W, false))
  var lx = newSeqWith(H, newSeqWith(W, false))
  var ly = newSeqWith(W, newSeqWith(H, false))
  var A, B = newSeq[int](N)
  var C, D = newSeq[int](M)
  for i in 0..<N:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  for i in 0..<M:
    C[i] = nextInt() - 1
    D[i] = nextInt() - 1
    bl[C[i]][D[i]] = true
  var ufx = newSeqWith(H, initDSU(W))
  var ufy = newSeqWith(W, initDSU(H))
  for i in 0..<H:
    for j in 0..<W:
      if bl[i][j]: continue
      if j + 1 < W and not bl[i][j + 1]:
        ufx[i].merge(j, j + 1)
      if i + 1 < H and not bl[i + 1][j]:
        ufy[j].merge(i, i + 1)
  for i in 0..<N:
    block:
      let l = ufx[A[i]].leader(B[i])
      lx[A[i]][l] = true
    block:
      let l = ufy[B[i]].leader(A[i])
      ly[B[i]][l] = true
  var ans = 0
  for i in 0..<H:
    for j in 0..<W:
      if bl[i][j]: continue
      light := false
      block:
        let l = ufx[i].leader(j)
        if lx[i][l]: light = true
      block:
        let l = ufy[j].leader(i)
        if ly[j][l]: light = true
      if light: ans.inc
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
