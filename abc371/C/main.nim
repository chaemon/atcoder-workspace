when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var
    P = (0 ..< N).toSeq
    G, H = Seq[N, N: false]
  for _ in nextInt():
    let u, v = nextInt() - 1
    G[u][v] = true
    G[v][u] = true
  for _ in nextInt():
    let u, v = nextInt() - 1
    H[u][v] = true
    H[v][u] = true
  var A = Seq[N, N: 0]
  for i in N:
    for j in i + 1 ..< N:
      A[i][j] = nextInt()
      A[j][i] = A[i][j]
  var
    ans = int.inf
  while true:
    var c = 0
    for u in N:
      for v in u + 1 ..< N:
        if H[u][v] != G[P[u]][P[v]]:
          c += A[u][v]
    ans.min=c
    if not P.nextPermutation(): break
  echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

