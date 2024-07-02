when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, A:int, B:int, C:int, D:int):
  var
    k = 0
    H0 = H
    ans0 = 0
    ans = int.inf
  # 2をk回使った後に1を使う
  while true:
    # H0からアイテム1を使い続ける
    ans.min=ans0 + (H0.ceilDiv A) * B
    H0 -= C
    ans0 += D
    if H0 > 0:
      H0 -= H0 div 2
    if H0 <= 0:
      ans.min= ans0
      break
  echo ans

when not defined(DO_TEST):
  var H = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(H, A, B, C, D)
else:
  discard

