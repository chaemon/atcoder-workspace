include atcoder/extra/header/chaemon_header
import atcoder/extra/structure/set_map

proc solve(N:int, a:seq[int]) =
  var v = newSeq[(int,int)]()
  for i in 0..<N:
    v.add((a[i], i))
  v.sort()
  var st = SortedSet.getType(int).init()
#  var st = initSortedSet[int]()

  var ans = 0
  for (a, i) in v:
    let j = st.lower_bound(i)
    var l, r:int
#    debug j
    if j == st.len:
      r = N - 1
    else:
      r = st.kth_element(j) - 1
    if j == 0:
      l = 0
    else:
      l = st.kth_element(j - 1) + 1
#    echo l, " ", r, " ", i, " ", a
#    echo (i - l + 1) * (r - i + 1)
    ans += (i - l + 1) * (r - i + 1) * a
    st.insert(i)
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, a);
  return

main()
#}}}
