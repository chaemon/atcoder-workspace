when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var ans = 0
  for i in N:
    var d = B[i] - A[i]
    d -= d mod 5
    if d mod 10 == 5:
      ans.inc
      d -= 5
    d -= d mod 50
    if d mod 100 == 50:
      ans.inc
      d -= 50
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

