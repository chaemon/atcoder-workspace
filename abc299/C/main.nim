when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  if S.count('-') == 0 or S.count('o') == 0:
    echo -1;return
  var
    i = 0
    ans = 0
  while S[i] == '-': i.inc
  while i < N:
    var j = i
    while j < N and S[j] == 'o': j.inc
    ans.max= j - i
    i = j
    while i < N and S[i] == '-': i.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

