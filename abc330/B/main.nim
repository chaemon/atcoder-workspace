when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, L:int, R:int, A:seq[int]):
  var ans:seq[int]
  for i in N:
    if A[i] <= L:
      ans.add L
    elif R <= A[i]:
      ans.add R
    else:
      ans.add A[i]
  echo ans.join(" ")
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, R, A)
else:
  discard

