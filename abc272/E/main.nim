when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N: int, M: int, A: seq[int]):
  # 0 .. Nに入る回数を求める
  var v = Seq[M + 1: Seq[int]]
  for i in N:
    # 0 <= A[i] + (i + 1) * k <= N
    # となるkの区間
    let
      a = (-A[i]).ceilDiv(i + 1)
      b = (N - A[i]).floorDiv(i + 1)
    for k in a .. b:
      # k回目
      if k in 1 .. M:
        let u = A[i] + (i + 1) * k
        doAssert u in 0 .. N
        v[k].add u
  for k in 1 .. M:
    v[k].sort
    v[k] = v[k].deduplicate(isSorted = true)
    for i in 0 ..< v[k].len:
      if v[k][i] != i:
        echo i
        break
      if i == v[k].len - 1:
        echo v[k].len
  Naive:
    discard
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard
