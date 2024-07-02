when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var B = A
  B.sort
  var S = Seq[N + 1: 0]
  for i in 0 ..< N << 1:
    S[i] = S[i + 1] + B[i]
  var ans:seq[int]
  for i in A.len:
    let j = B.upperBound(A[i])
    ans.add S[j]
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

