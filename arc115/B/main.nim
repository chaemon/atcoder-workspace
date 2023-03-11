include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(N:int, C:seq[seq[int]]) =
  min_val := int.inf
  var mi, mj = -1
  for i in 0..<N:
    for j in 0..<N:
      if min_val > C[i][j]:
        min_val = C[i][j]
        mi = i
        mj = j
  var A, B = Seq(N, int)
  A[mi] = min_val
  B[mj] = 0
  for i in 0..<N:
    if i == mi: continue
    A[i] = C[i][mj] - B[mj]
  for j in 0..<N:
    if j == mj: continue
    B[j] = C[mi][j] - A[mi]
  for i in 0..<N:
    for j in 0..<N:
      if A[i] + B[j] != C[i][j]:
        echo NO;return
  echo YES
  echo A.join(" ")
  echo B.join(" ")
  return

# input part {{{
block:
  var N = nextInt()
  var C = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, C)
#}}}

