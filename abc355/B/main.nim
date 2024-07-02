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
solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var C = Seq[tuple[v, t:int]]
  for i in N:
    C.add (A[i], 0)
  for i in M:
    C.add (B[i], 1)
  C.sort
  for i in C.len - 1:
    if C[i].t == 0 and C[i + 1].t == 0:
      echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
else:
  discard

