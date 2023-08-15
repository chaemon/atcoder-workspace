when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, N:int):
  proc convert(S:string):int =
    result = 0
    for i in 0 ..< S.len:
      result *= 2
      if S[i] == '1': result.inc
  block:
    var S = S
    for i in S.len:
      if S[i] == '?': S[i] = '0'
    if S.convert > N: echo -1;return
  var S = S
  for i in S.len:
    if S[i] != '?': continue
    # S[i]を1にしてみる
    S[i] = '1'
    ok := false
    block:
      var
        S = S
      for j in i + 1 ..< S.len:
        if S[j] == '?':
          S[j] = '0'
      if S.convert <= N: ok = true
    # S[i]は0
    if not ok:
      S[i] = '0'
  echo S.convert

when not defined(DO_TEST):
  var S = nextString()
  var N = nextInt()
  solve(S, N)
else:
  discard

