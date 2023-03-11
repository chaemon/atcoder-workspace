include atcoder/extra/header/chaemon_header
import atcoder/segtree

var N:int
var K:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

const T = 300000

var st = initSegtree(T + 1, (a:int, b:int)=>max(a, b), () => -int.inf)

proc main() =
  for i in 0..<N:
    let
      l = max(0, A[i] - K)
      r = min(T, A[i] + K)
      u = st.prod(l..r)
    if st.get(A[i]) == -int.inf:
      st.set(A[i], 1)
    let p = st.get(A[i])
    st.set(A[i], max(u + 1, p))
  echo st.all_prod()
  return

main()

