when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import times

solveProc solve(S:string):
  var d = parse(S, "YYYY/MM/dd", utc())
  while true:
    var
      u = d.format("YYYYMMdd")
      s = initSet[char]()
    for c in u:
      s.incl c
    if s.len <= 2:
      break
    d += 1.days
  echo d.format("YYYY/MM/dd")
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

