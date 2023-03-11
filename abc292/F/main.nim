when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search_float
import complex

solveProc solve(A:int, B:int):
  var
    A = A.float
    B = B.float
    C = sqrt(A^2 + B^2)
  if A > B: swap A, B
  # A <= B
  # 長さlの辺を作ってみて角度が60°(π/3)以上ならtrue
  proc f(l:float):bool =
    let
      y = sqrt(l^2 - A^2)
      x = sqrt(max(0.0, l^2 - B^2))
      p = complex(A, y)
      q = complex(x, B)
      theta = phase(q / p)
    return theta >= PI / 3.0
  # trueになる最大値を二分探索
  echo f.max_right(A .. C)
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

