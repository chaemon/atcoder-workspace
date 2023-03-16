when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/modint
import lib/math/matrix
type mint = modint

solveProc solve(A:int, X:int, M:int):
  mint.setMod(M)
  type MT = StaticMatrixType(mint)
  var
    A = MT.init([[A, 0], [1, 1]])
    b = MT.initVector([1, 0])
  b = A^X * b
  echo b[1]
  discard

when not defined(DO_TEST):
  let A, X, M = nextInt()
  solve(A, X, M)
else:
  discard

