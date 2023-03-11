include atcoder/extra/header/chaemon_header

var N:int
var K:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N-1-0+1, nextInt())
#}}}

import atcoder/segtree

proc op(a, b:int):int = min(a, b)
proc e():int = int.inf

proc main() =
  var
    st = initSegTree(A, op, e)
    rest = 0
    d:int
    ans = 0
    j = 0
  for i in 0..<N:
    d = A[i]
    var r = st.max_right(i, (x:int) => x >= d)
    let s = min(K - rest, N - j)
    let b = r - j
    var n:int
    if b >= s: # jump s
      n = s
    elif b >= 0: # jump b
      n = b
    ans += n * A[i]
    rest += n
    j += n
    rest.dec
  print ans
  return

main()
