when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  if S.count("Perfect") == N:
    echo "All Perfect"
  else:
    var isfullcombo = true
    for s in S:
      if s notin ["Perfect", "Great"]:
        isfullcombo = false
    if isfullcombo:
      echo "Full Combo"
    else:
      echo "Failed"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

