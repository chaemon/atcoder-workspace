when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree
import sugar

solveProc solve(N:int, B:seq[int]):
  var
    c = B.toSeq.sorted.deduplicate()
    st_top, st_bottom = initSegTree[int](c.len, (a, b:int)=>max(a, b), ()=>0)
  for i in N:
    let
      Bi = c.lowerBound(B[i])
      t = st_bottom[0 ..< Bi]
      u = st_top[Bi + 1 .. ^1]
    st_top[Bi] = max(t + 1, st_top[Bi])
    st_bottom[Bi] = max(u + 1, st_bottom[Bi])
  echo max(st_top.allProd(), st_bottom.allProd())
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var B = newSeqWith(N, nextInt())
  solve(N, B)
else:
  discard

