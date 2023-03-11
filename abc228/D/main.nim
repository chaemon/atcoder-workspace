const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/extra/structure/set_map

const N = 2^20

solveProc solve(Q:int, t:seq[int], x:seq[int]):
  var not_engaged = initSortedSet[int]()
  var A = Seq[N: -1]
  for i in N:
    not_engaged.insert(i)
  for i in Q:
    if t[i] == 1:
      var it = not_engaged.lower_bound(x[i] mod N)
      if it == not_engaged.end():
        it = not_engaged.begin()
      let j = *it
      not_engaged.erase(it)
      A[j] = x[i]
    else:
      echo A[x[i] mod N]
  return


when not DO_TEST:
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    x[i] = nextInt()
  solve(Q, t, x)
else:
  discard

