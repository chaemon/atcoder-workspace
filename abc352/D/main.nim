when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/set_map

solveProc solve(N:int, K:int, P:seq[int]):
  Pred P
  var
    pos = Seq[N: int]
    ans = int.inf
  for i in N:
    pos[P[i]] = i
  var s = initSortedSet[int]()
  for i in K:
    s.incl pos[i]
  block:
    var
      it = s.end()
    it.dec
    ans.min= *it - *s.begin()
  for a in 1 .. N - K:
    s.erase pos[a - 1]
    s.incl pos[a + K - 1]
    block:
      var
        it = s.end()
      it.dec
      ans.min= *it - *s.begin()
  echo ans
  discard


when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, K, P)
else:
  discard

