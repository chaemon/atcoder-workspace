when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(M:int):
  var
    M = M
    A:seq[int]
  for a in 0 .. 10:
    let r = M mod 3
    for _ in r:
      A.add a
    M = M div 3
  echo A.len
  echo A.join(" ")
  discard

when not defined(DO_TEST):
  var M = nextInt()
  solve(M)
else:
  discard

