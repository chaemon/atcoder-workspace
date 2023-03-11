include atcoder/extra/header/chaemon_header

const DEBUG = true
const DO_TEST = false

solveProc solve(N:int, L:seq[int], R:seq[int]):
  var dp = Seq[100, 100: -1]
  for i in 0..<100: dp[i][i] = 0
  proc calc(l, r:int):int =
    t =& dp[l][r]
    if t >= 0: return t
    var a = initSet[int]()
    for i in 0..<N:
      if R[i] <= l or r <= L[i]: continue
      if l <= L[i] and R[i] <= r:
        a.incl(calc(l, L[i]) xor calc(R[i], r))
    t = 0
    while t in a: t.inc
    return t
  echo if calc(0, 99) == 0: "Bob" else: "Alice"

let T = nextInt()
for _ in T:
  let N = nextInt()
  let (L, R) = unzip(N, (nextInt() - 1, nextInt() - 1))
  solve(N, L, R, true)

