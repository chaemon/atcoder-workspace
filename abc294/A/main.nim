when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var ans:seq[int]
  for i in N:
    let A = nextInt()
    if A mod 2 == 0:
      ans.add A
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

