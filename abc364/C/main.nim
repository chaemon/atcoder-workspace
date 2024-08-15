when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, A:seq[int], B:seq[int]):
  var
    ans = int.inf
  proc f(A:seq[int], X:int) =
    var
      A = A.sorted(SortOrder.Descending)
      s = 0
      c = 0
    for i in N:
      s += A[i]
      c.inc
      if s > X: break
    ans.min=c
  f(A, X)
  f(B, Y)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, X, Y, A, B)
else:
  discard

