const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  var a, b = Seq[N, N: false]
  for i in M:
    a[A[i]][B[i]] = true
    a[B[i]][A[i]] = true
    b[C[i]][D[i]] = true
    b[D[i]][C[i]] = true
  var p = (0..<N).toSeq
  while true:
    valid := true
    for x in N:
      for y in N:
        if a[x][y] != b[p[x]][p[y]]:
          valid = false
    if valid:
      echo YES;return
    if not p.nextPermutation: break
  echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  var C = newSeqWith(M, 0)
  var D = newSeqWith(M, 0)
  for i in 0..<M:
    C[i] = nextInt() - 1
    D[i] = nextInt() - 1
  solve(N, M, A, B, C, D)
else:
  discard

