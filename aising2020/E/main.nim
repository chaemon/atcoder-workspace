const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/set_map

proc solve() =
  let N = nextInt()
  var K, L, R = newSeq[int](N)
  for i in 0..<N:
    K[i] = nextInt() - 1
    L[i] = nextInt()
    R[i] = nextInt()
  proc calc(v:seq[tuple[d, L:int]]):int =
    var s = initSortedSet[int]()
    for i in v.len:
      s.insert(i)
    result = 0
    for (d, L) in v:
      # sからL以下の最大値を探す
      var it = s.upperBound(L)
      if it == s.begin():
        continue
      it.dec
      result += d
      s.erase(it)
  var
    ls, rs = Seq[tuple[d, L:int]]
    s = 0
  for i in 0..<N:
    let d = L[i] - R[i]
    if d >= 0:
      ls.add (d, K[i])
      s += R[i]
    else:
      rs.add (-d, N - 2 - K[i])
      s += L[i]
  ls.sort(SortOrder.Descending)
  rs.sort(SortOrder.Descending)
  echo s + calc(ls) + calc(rs)

proc main() =
  let T = nextInt()
  for _ in 0..<T: solve()
  return

main()

