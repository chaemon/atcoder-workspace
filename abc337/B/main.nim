when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string):
  for i in 0 .. S.len:
    for j in 0 .. S.len:
      for k in 0 .. S.len:
        if i + j + k != S.len: continue
        let S0 = 'A'.repeat(i) & 'B'.repeat(j) & 'C'.repeat(k)
        if S0 == S:
          echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

