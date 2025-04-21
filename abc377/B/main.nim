when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:seq[string]):
  var row, col = Seq[8: false]
  for x in 8:
    for y in 8:
      if S[x][y] == '#':
        row[x] = true
        col[y] = true
  ans := 0
  for x in 8:
    for y in 8:
      if S[x][y] == '.':
        if row[x] or col[y]: continue
        ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var S = newSeqWith(8, nextString())
  solve(S)
else:
  discard

