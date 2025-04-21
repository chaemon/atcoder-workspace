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
solveProc solve(N:int, S:string):
  if S.len mod 2 == 0: echo NO;return
  if S.len == 1 and S[0] == '/':
    echo YES;return
  let d = S.len div 2
  if S[0 ..< d] == '1'.repeat(d) and S[d] == '/' and S[d + 1 ..< 2 * d + 1] == '2'.repeat(d):
    echo YES
  else:
    echo NO
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

