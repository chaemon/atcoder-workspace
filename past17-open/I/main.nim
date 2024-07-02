when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, S:seq[string]):
  var
    ct = initTable[string, int]()
    ans = 0
  for i in N:
    ct[S[i]].inc
  for i in N:
    var u = initSet[string]()
    for b in 1 ..< 2^S[i].len:
      var s = ""
      for j in S[i].len:
        if b[j] == 1:
          s.add S[i][j]
      u.incl s
    for s in u:
      if s in ct:
        ans += ct[s]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

