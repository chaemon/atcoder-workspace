when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var A = A
  while true:
    var found = false
    for i in A.len - 1:
      if abs(A[i] - A[i + 1]) != 1:
        var s:seq[int]
        found = true
        if A[i] < A[i + 1]:
          for j in A[i] + 1 .. A[i + 1] - 1:
            s.add j
          A = A[0 .. i] & s &  A[i + 1 .. ^1]
        else:
          for j in A[i + 1] + 1 .. A[i] - 1 << 1:
            s.add j
          A = A[0 .. i] & s &  A[i + 1 .. ^1]
    if not found:
      break
  echo A.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

