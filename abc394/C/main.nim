when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  # *WWWWWWWA -> *ACCCCCCC
  var
    ans = ""
    wcount = 0
  for s in S:
    if s == 'W':
      wcount.inc
    else:
      if wcount > 0:
        if s == 'A':
          ans.add 'A'
          ans &= 'C'.repeat(wcount)
        else:
          ans &= 'W'.repeat(wcount)
          ans.add s
        wcount = 0
      else:
        ans.add s
  ans.add 'W'.repeat(wcount)
  echo ans

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

