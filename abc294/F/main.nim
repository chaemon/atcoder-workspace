when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search_float

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  proc f(p:float):bool =
    var
      a:seq[float]
      ct = 0
    for i in M:
      a.add (1.0 - p) * float(C[i]) - p * float(D[i])
    a.sort()
    for i in N:
      let u = (1.0 - p) * float(A[i]) - p * float(B[i])
      #debug i, u
      ct += a.upper_bound(-u)
    return ct >= N * M - K + 1
  echo f.minLeft(0.0 .. 1.0) * 100.0
  discard

when not defined(DO_TEST):
  let N, M, K = nextInt()
  var A, B, C, D:seq[int]
  for i in N:
    A.add nextInt()
    B.add nextInt()
  for i in M:
    C.add nextInt()
    D.add nextInt()
  solve(N, M, K, A, B, C, D)
else:
  discard

