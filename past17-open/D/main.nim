when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int, C:int, x:seq[int]):
  var ans = C
  block:
    # 無料会員
    s := 0
    for i in x.len:
      s += max(0, x[i] - 3) * A
    ans.min=s
  block:
    # 一般会員
    s := B
    for i in x.len:
      s += max(0, x[i] - 50) * A
    ans.min=s
  echo ans
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var x = newSeqWith(12, nextInt())
  solve(A, B, C, x)
else:
  discard

