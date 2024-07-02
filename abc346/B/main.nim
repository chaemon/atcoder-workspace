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
solveProc solve(W:int, B:int):
  let S = "wbwbwwbwbwbw".repeat(100)
  for i in S.len - W - B:
    let S = S[i ..< i + W + B]
    if S.count('w') == W and S.count('b') == B:
      echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var W = nextInt()
  var B = nextInt()
  solve(W, B)
else:
  discard

