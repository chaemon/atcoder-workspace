when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  proc calc(s:string):int =
    if s[^1] == '-':
      return s.find('-')
    else:
      return s.find('.') + 5
  ans := ""
  for s in S:
    ans.add '0' + calc(s)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

