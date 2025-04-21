when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  var
    v = Seq[tuple[l, i: int]]
    ans: string
  for i in N:
    v.add (S[i].len, i)
  v.sort
  for (l, i) in v:
    ans.add S[i]
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

