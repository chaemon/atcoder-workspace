when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  var m = 0
  for i in N:
    m.max=S[i].len
  var ans = Seq[m: '*'.repeat(N)]
  for i in N:
    for j in S[i].len:
      ans[j][N - 1 - i] = S[i][j]
  for s in ans.mitems:
    var u = s.len - 1
    while s[u] == '*':
      u.dec
    s = s[0 .. u]
  echo ans.join("\n")

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

