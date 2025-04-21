when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int):
  var
    A:seq[int]
    ans:seq[seq[int]]
  proc f() =
    if A.len == N:
      ans.add A
    else:
      var
        s = 1
        r = N - A.len
      if A.len > 0:
        s = A[^1] + 10
      while true:
        if s + (r - 1) * 10 > M: break
        A.add s
        f()
        discard A.pop
        s.inc
  f()
  echo ans.len
  for A in ans:
    echo A.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

