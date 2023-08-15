when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:seq[int]):
  var ans = 0u
  for i in A.len:
    if A[i] == 1:
      ans = ans or (1u shl i)
  echo ans
  discard

when not defined(DO_TEST):
  var A = newSeqWith(63+1, nextInt())
  solve(A)
else:
  discard

