include atcoder/extra/header/chaemon_header


const DEBUG = true

let N, M = nextInt()
var A = Seq[N: seq[int]]
for i in N:
  let K = nextInt()
  for j in K:
    A[i].add nextInt() - 1
let P, Q = nextInt()
let B = (Seq[P: nextInt() - 1]).toSet

var ans = 0
for i in N:
  var ct = 0
  for j in A[i].len:
    if A[i][j] in B: ct.inc
  if ct >= Q: ans.inc
echo ans
