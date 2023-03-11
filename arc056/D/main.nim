include src/nim_acl/header
import src/nim_acl/lazysegtree

let
  N = nextInt()
  w = newSeqWith(N, nextInt())

type D = int
type L = int

proc f(a, b:D):D = max(a, b)
proc g(d:D, l:L):D = d + l
proc h(a, b:L):L = a + b
proc op():D = -int.inf
proc id():L = 0


var
  t = newSeqWith(N, newSeq[int]())
  v = newSeq[int]()

for i in 0..<N:
  let M = nextInt()
  t[i] = newSeqWith(M, nextInt())
  v.add(t[i])

v = v.toHashSet.toSeq.sorted


var e = newSeq[seq[int]](v.len)

for i in 0..<N:
  for t in t[i].mitems:
    t = v.binarySearch(t)
    e[t].add(i)

var
  prev = newSeqWith(N, -1)
  st = init_lazy_segtree(v.len + 1, f, op, g, h, id)

var ans = 0

st.set(0, 0)

for t in 0..<v.len:
  let u = st.all_prod()
  ans.max=u
  st.set(t + 1, u)
  for i in e[t]:
    st.apply(prev[i] + 1..t + 1, w[i])
    prev[i] = t + 1

ans.max=st.all_prod
echo ans
