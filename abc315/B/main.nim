when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(M:int, D:seq[int]):
  var v:seq[(int, int)]
  for i in M:
    for j in D[i]:
      v.add((i + 1, j + 1))
  let p = v[v.len div 2]
  echo p[0], " ", p[1]
  discard

when not defined(DO_TEST):
  var M = nextInt()
  var D = newSeqWith(M, nextInt())
  solve(M, D)
else:
  discard

