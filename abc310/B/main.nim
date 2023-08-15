when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var
    P, C = Seq[N: int]
    F = Seq[N: seq[int]]
  for i in N:
    P[i] = nextInt()
    C[i] = nextInt()
    for _ in C[i]:
      F[i].add nextInt()
  for i in N:
    for j in N:
      var ok = true
      if not (P[i] >= P[j]): ok = false
      for f in F[i]:
        if f notin F[j]: ok = false
      if not (P[i] > P[j] or F[j] != F[i]): ok = false
      if ok:
        echo YES;return
  echo NO
  discard

when not DO_TEST:
  solve()
else:
  discard

