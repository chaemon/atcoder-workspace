when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:string):
  var
    N = N
    ans:seq[string]
  for _ in 2:
    N = N[1 .. ^1] & N[0]
    ans.add N
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextString()
  solve(N)
else:
  discard
