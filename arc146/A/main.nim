const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var A = A
  A.sort
  A.reverse
  var
    a = @[0, 1, 2]
    ans = -int.inf

  while true:
    var s = parseInt($A[a[0]] & $A[a[1]] & $A[a[2]])
    ans.max=s
    if not a.nextPermutation: break
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

