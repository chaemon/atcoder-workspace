when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string, T:string):
  var U = '0'.repeat(N)
  s := 0
  t := 0
  for i in N:
    if S[i] != T[i]:
      if S[i] == '0':
        s.inc
      elif T[i] == '0':
        t.inc
      else:
        doAssert false
  var k = s + t
  if k mod 2 == 1:
    echo -1;return
  sc := 0
  tc := 0
  k.div=2
  for i in N:
    if S[i] == T[i]: U[i] = '0';continue
    if S[i] == '0':
      if sc < k:
        U[i] = '0'
        sc.inc
      else:
        U[i] = '1'
        tc.inc
    elif T[i] == '0':
      if tc < k:
        U[i] = '0'
        tc.inc
      else:
        U[i] = '1'
        sc.inc
  echo U
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

