when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[string], V:seq[string]):
  var
    solved = 6 @ false
    ans = 6 @ -1
  for i in N:
    let j = P[i][0] - 'A'
    if solved[j] or V[i] == "WA": continue
    ans[j] = i + 1
    solved[j] = true
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, "")
  var V = newSeqWith(N, "")
  for i in 0..<N:
    P[i] = nextString()
    V[i] = nextString()
  solve(N, P, V)
else:
  discard

