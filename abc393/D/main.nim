when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  let
    u = S.count('1')
    M = (u + 1) div 2
  var
    ct = 0
    T = '0'.repeat(N)
    found = false
  for i in N + 1:
    # 0 ..< i, i ..< N
    if ct == M:
      for j in M:
        T[i - 1 - j] = '1'
      for j in u - M:
        T[i + j] = '1'
      found = true
      break
    if i == N: break
    if S[i] == '1':
      ct.inc
  var
    i, j, ans = 0
  for _ in u:
    while S[i] == '0': i.inc
    while T[j] == '0': j.inc
    ans += abs(i - j)
    i.inc;j.inc
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

