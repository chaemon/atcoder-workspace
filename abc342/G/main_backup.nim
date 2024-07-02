when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/extra/structure/lazysegtree_2d

proc op(a, b:int):int = a + b
proc e():int = 0
proc mapping(f, s:int):int = max(f, s)
proc composition(f1, f2:int):int = max(f1, f2)
proc id():int = -int.inf

# Failed to predict input format
solveProc solve():
  var v:seq[tuple[x, y:int]]
  var st = initLazySegTree2D[int, int](v, op, e, mapping, composition, id)
  discard

when not DO_TEST:
  solve()
else:
  discard

