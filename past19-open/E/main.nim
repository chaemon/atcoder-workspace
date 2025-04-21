when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  var
    i = 0
    ans = ""
  while i < N:
    if S[i] == '/' and i + 1 < N and S[i + 1] == '*':
      var
        j = i + 2
      while j < N:
        if S[j] == '*' and j + 1 < N and S[j + 1] == '/':
          break
        j.inc
      if j == N:
        ans &= S[i ..< N]
        break
      else:
        i = j + 2
    else:
      ans.add S[i]
      i.inc
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard
