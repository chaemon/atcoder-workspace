when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(R:int, C:int, B:seq[string]):
  var ans = B
  for i in R:
    for j in C:
      if ans[i][j] != '#':
        ans[i][j] = '.'
  for x in R:
    for y in C:
      if B[x][y] in '1' .. '9':
        let d = B[x][y] - '0'
        for i in R:
          for j in C:
            if abs(x - i) + abs(y - j) <= d:
              ans[i][j] = '.'
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var C = nextInt()
  var B = newSeqWith(R, nextString())
  solve(R, C, B)
else:
  discard

