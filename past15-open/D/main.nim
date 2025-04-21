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
solveProc solve(A:int, B:int, C:int, D:int, R:int):
  var yoyaku = Seq[2000 + 1: false]
  for t in A .. A + R: yoyaku[t] = true
  for t in 0 .. 2000:
    if t mod D == 0:
      if B <= t:
        var
          p = C
          q = C + R
        for t2 in max(p, t) .. q:
          yoyaku[t2] = true
  for t in C .. C + R:
    if not yoyaku[t]:
      echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var R = nextInt()
  solve(A, B, C, D, R)
else:
  discard

