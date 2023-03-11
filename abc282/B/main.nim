when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, S:seq[string]):
  ans := 0
  for i in N:
    for j in i + 1 ..< N:
      ok := true
      for k in M:
        if S[i][k] == 'x' and S[j][k] == 'x': ok = false
      if ok: ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

