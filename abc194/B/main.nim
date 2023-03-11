include atcoder/extra/header/chaemon_header


const DEBUG = true

let N = nextInt()
var A, B = Seq(N, int)
for i in 0..<N:
  A[i] = nextInt()
  B[i] = nextInt()

var ans = int.inf
for i in 0..<N:
  ans.min=A[i] + B[i]

for i in 0..<N:
  for j in 0..<N:
    if i == j: continue
    ans.min=max(A[i], B[j])

echo ans

