when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  if N < 10^3: echo N
  elif N < 10^4: echo (N div 10) * 10
  elif N < 10^5: echo (N div 10^2) * 10^2
  elif N < 10^6: echo (N div 10^3) * 10^3
  elif N < 10^7: echo (N div 10^4) * 10^4
  elif N < 10^8: echo (N div 10^5) * 10^5
  elif N < 10^9: echo (N div 10^6) * 10^6
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

