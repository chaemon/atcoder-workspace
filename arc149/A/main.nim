when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int):
  ans := "z"
  for d in 1 .. 9:
    var
      s = 0
      m = 0
    while true:
      s *= 10
      s += d
      m.inc
      if m > N: break
      s.mod=M
      if s == 0:
        let S = ('0' + d).repeat(m)
        if ans == "z" or ans.len < S.len:
          ans = S
        elif ans.len == S.len:
          ans.max=S
  if ans == "z":
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

