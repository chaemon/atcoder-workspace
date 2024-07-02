when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let N, Q = nextInt()
  var C = Seq[N: nextInt() - 1]
  var
    v = Seq[N: Seq[int32]]
    id = (0 ..< N).toSeq
  for i in N:
    v[i].add C[i].int32
  for _ in Q:
    let
      a, b = nextInt() - 1
      ia = id[a]
      ib = id[b]
    if v[ia].len >= v[ib].len:
      v[ia] &= v[ib]
      v[ia].sort
      v[ia] = v[ia].deduplicate(isSorted = true)
      v[ib].setLen 0
      id[b] = ia
      id[a] = ib
    else:
      v[ib] &= v[ia]
      v[ib].sort
      v[ib] = v[ib].deduplicate(isSorted = true)
      v[ia].setLen 0
      id[b] = ib
      id[a] = ia
    echo v[id[b]].len
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

