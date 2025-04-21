when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var
    ct = Seq[N: 0]
    ans = M * (M - 1) div 2
  for i in M:
    ct[(A[i] + B[i]) mod N].inc
  for i in ct.len:
    ans -= ct[i] * (ct[i] - 1) div 2
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

