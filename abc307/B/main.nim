when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, S:seq[string]):
  for i in N:
    for j in N:
      if i == j: continue
      var
        T = S[i] & S[j]
        U = T
      U.reverse
      if T == U:
        echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

