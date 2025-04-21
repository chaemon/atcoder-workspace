when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, M:int):
  var (H, M) = (H, M)
  while true:
    proc f(H, M:int):bool =
      let
        A = H div 10
        B = H mod 10
        C = M div 10
        D = M mod 10
      let
        H1 = A * 10 + C
        M1 = B * 10 + D
      if H1 in 0 ..< 24 and M1 in 0 ..< 60:
        return true
      else:
        return false
    if f(H, M):
      echo H, " ", M
      return
    M.inc
    if M == 60:
      M = 0
      H.inc
      if H == 24:
        H = 0
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var M = nextInt()
  solve(H, M)
else:
  discard

